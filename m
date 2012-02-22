Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2BVGNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:13:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34376 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2BVGNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:13:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.169.9 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-9-git-send-email-swarren@nvidia.com>
	<CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
Date: Wed, 22 Feb 2012 07:13:43 +0100
Message-ID: <CACRpkdaTUJWN_kr3UB-fdNiU-udFqqx93cYG_q6p9n_e4d6OLA@mail.gmail.com>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a NULL
 name field
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 6:46 PM, Stephen Warren <swarren@nvidia.com> wrote:

> I guess we could just modify pinmux_get() such that if NULL is passed as
> the state name, it uses "default" instead internally. The disadvantage I
> see here is that someone reading the client driver and writing the mapping
> table then has to know that pinmux_get() does that internally, rather than
> it being obvious right in the client driver code.

I would prefer this solution, it has the upside of not needing to touch
the sirf driver.

And please #define the string somewhere instead of open-coding
"default", it's too errorprone IMO.

Thanks,
Linus Walleij
