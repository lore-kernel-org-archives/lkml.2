Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2BVG0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:26:44 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:32760 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751459Ab2BVG0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:26:42 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Feb 2012 14:34:41 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Message-ID: <20120222063440.GB11087@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 09:46:01AM -0800, Stephen Warren wrote:
....
> > we might just
> > 
> > #define PIN_MAP_NAME_DEFAULT "default"
> > In <linux/pinctrl/consumer.h> and <linux/pinctrl/machine.h> alike,
> > maybe in some <linux/pinctrl/mapnames.h> that both of these
> > include?
> > 
> > the have the driver ask for:
> > 
> > sirfport->p = pinctrl_get(&pdev->dev, PIN_MAP_NAME_DEFAULT);
> > 
> > (Similar changes can be done for U300, naming all its map
> > "default".)
> 
> I guess we could just modify pinmux_get() such that if NULL is passed as
> the state name, it uses "default" instead internally. The disadvantage I
> see here is that someone reading the client driver and writing the mapping
> table then has to know that pinmux_get() does that internally, rather than
> it being obvious right in the client driver code.
> 
It looks like a way out.
The left problem seems to be that we may force the mapping table writer to
specify "default" name for map at least.
Is there any way to avoid it?
I just think it may be better if we do not have such restriction.

Regards
Dong Aisheng

