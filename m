Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1KLOTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 09:19:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1KLOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 09:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAJuYYwS465WW-Xp6gk5hzKArTZGzmc6nh+-XR=BPusGfTU=DXw@mail.gmail.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
	<CACRpkdY8YXooD5ChHqQnERPPGhk7TgUvL=TodAPY8Jit9eS=fw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805421@HQMAIL01.nvidia.com>
	<CACRpkdaArzSfUVgPo0vVEAUNKwZO7W5yhjJpeEQiFK20RQS2Ag@mail.gmail.com>
	<CAJuYYwS465WW-Xp6gk5hzKArTZGzmc6nh+-XR=BPusGfTU=DXw@mail.gmail.com>
Date: Sat, 12 Nov 2011 15:19:53 +0100
Message-ID: <CACRpkda06ZvxABSjs3PvL2hE8-0uBNonH83=qZG+yS0fax69AA@mail.gmail.com>
Subject: Re: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 12:22 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Another question, not related to the above. The gpio and pinctrl
> drivers would operate on the same physical memory space (pinmux and
> gpio is just a single controller). Both gpio and pinctrl driver would
> do a ioremap of this physical address space. I remember reading that
> ioremap of the same physical memory area twice is not correct. So any
> suggestions on how to handle this.

Yes, create one single driver in a single file that presents a pinctrl *and*
a gpiolib interface. Put the driver in drivers/pinctrl/pinctrl-foo.c.
That's the most natural design pattern methinks. Trying to artificially
break it apart in two driver files doesn't make sense.

Linus Walleij
