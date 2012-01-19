Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729Ab2ASSOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:14:09 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53463 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab2ASSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZS9OVv8osoc5E1KOcqfFnvECnKJzM1kXZ9qNKQMZgB=w@mail.gmail.com>
References: <1323431857-8828-1-git-send-email-linus.walleij@stericsson.com>
	<CAJuYYwT+pNdt6G07Gx7TqkpGBQEnmMGxsHSE2mew9qUjO-ES5Q@mail.gmail.com>
	<CACRpkdZS9OVv8osoc5E1KOcqfFnvECnKJzM1kXZ9qNKQMZgB=w@mail.gmail.com>
Date: Thu, 19 Jan 2012 23:44:04 +0530
Message-ID: <CAJuYYwRzi-BAaXLK4Xm3kd62rVDcwX1xureAJ4yu64kZo0NKhg@mail.gmail.com>
Subject: Re: [PATCH v6] pinctrl: add a pin config interface
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 19 January 2012 22:28, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jan 18, 2012 at 8:16 AM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>
>> In case of runtime pinmuxing, the pin configuration would also be
>> required to be setup in some cases. pin_config_set() is suitable to be
>> called from the platform code. In case of runtime pinmuxing in driver
>> code, is there any way to set the pin config also at runtime in driver
>> code?
>
> Yes that is already possible today with the pin_config_set() and
> pin_config_group_set() calls already merged for 3.3.
>
> However there is no relation between the struct device and these
> config settings so I feel that this is a bit hack-ish, but it was
> atleast something we could agree upon.

[Resending this email]

Using pin_config_set() from drivers did not seem correct. The concern
here is that all three parameters of pin_config_set() are specific to
a particular platform. Hence, using it in driver means that the driver
will no more be usable across multiple different platforms.

But that was not the case with pinmux_get() and pinmux_put(). Will
there be support added in pinctrl subsystem to allow drivers to
configure pin-config settings from drivers and be compatible for
multiple platforms?

Thanks,
Thomas.

>
> Thanks,
> Linus Walleij
