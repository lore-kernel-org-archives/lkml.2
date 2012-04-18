Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2DRLbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:31:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48078 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2DRLbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120417034210.GD17173@shlinux2.ap.freescale.net>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
	<4F8C42D6.2000607@wwwdotorg.org>
	<20120417034210.GD17173@shlinux2.ap.freescale.net>
Date: Wed, 18 Apr 2012 13:31:17 +0200
Message-ID: <CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 5:42 AM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:

> I think the main issue is for one platform neither supports dt nor using pinctrl
> subsystem, do you think it still makes too much sense to force that platform
> to define a _PINCTRL_ dummy state in their machine code?
>
> But the driver is commonly shared between these different platforms(using pinctrl
> or not).

So this is for the situation where some machines have pinctrl and some haven't.

And I think that's how some archs have used the regulator dummies earlier,
so I clearly see the point. So if converting a subset of machines in an
architecture you will need this for a transitional period.

Is this helpful to get i.MX support in place?

On one hand I'd say we merge it for that reason alone, instead of requiring
all i.MX machines to be converted at once.

On the other hand, I fear that this will be used to avoid *ever* migrating
the old machines to pinctrl. And it's a generic disease that people working
in the arch/arm/* tree want to ditch old hardware without actually deleting
the code.

I'd like Sascha's view on this to make a good decision.

Yours,
Linus Walleij
