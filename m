Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2DYLj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:39:58 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57594 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab2DYLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:39:57 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371I179dN1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 25 Apr 2012 19:49:56 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 1/2] pinctrl: add pinctrl_provide_dummies interface
 for platforms to use
Message-ID: <20120425114955.GB17631@shlinux2.ap.freescale.net>
References: <1335260023-15859-1-git-send-email-b29396@freescale.com>
 <4F96F847.508@wwwdotorg.org>
 <20120425094934.GA17631@shlinux2.ap.freescale.net>
 <CACRpkdYjVYsM-Qo7NWKx5Mr3rAmp12G_wAtkmNkkqNyX=ZeKUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdYjVYsM-Qo7NWKx5Mr3rAmp12G_wAtkmNkkqNyX=ZeKUw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 07:19:43PM +0800, Linus Walleij wrote:
> On Wed, Apr 25, 2012 at 11:49 AM, Dong Aisheng
> <aisheng.dong@freescale.com> wrote:
> > On Wed, Apr 25, 2012 at 03:00:23AM +0800, Stephen Warren wrote:
> 
> >> The only thing that should be calling pinctrl_request_gpio() is a GPIO
> >> driver. It should only be calling it for the GPIOs it manages. I'd
> >> expect that if a platform's pinctrl driver was not yet written to
> >> support the GPIO functionality, then the GPIO driver would not be
> >> calling this function.
> >>
> > Hmm, pinctrl gpio is in the same situation as pinctrl state that gpio
> > driver may be shared between several platforms, with pinctrl support
> > or not.
> 
> I think it's mostly safe to assume that either:
> 
I just saw your reply after i sent out the revised patch...

> - pinctrl calls from GPIO drivers gets stubbed out totally due to
>   CONFIG_PINCTRL not being selected
> 
Yes, we already have that in include/linux/pinctrl/consumer.h

> or:
> 
> - You need to pass a token through platform data to the
>   GPIO driver telling it whether it needs to request pins for
>   it's GPIOs or not. Just a bool should work fine?
> 
Yes, this is an alternative way.
I'm using a similar way, but pass the data to pinctrl core
rather than gpio driver. Then it is be handled together with
dummy state in platform code.

Do you think if the current way i used is ok?
Or i need to change to your proposed way?

Regards
Dong Aisheng

