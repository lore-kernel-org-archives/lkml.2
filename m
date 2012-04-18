Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2DRO2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:28:09 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54852
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab2DRO2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:28:08 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 18 Apr 2012 22:38:40 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
Message-ID: <20120418143839.GB30966@shlinux2.ap.freescale.net>
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>
 <4F8C42D6.2000607@wwwdotorg.org>
 <20120417034210.GD17173@shlinux2.ap.freescale.net>
 <CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>
 <20120418122832.GP20478@pengutronix.de>
 <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
 <20120418140046.GU3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120418140046.GU3852@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:00:46PM +0800, Sascha Hauer wrote:
> On Wed, Apr 18, 2012 at 03:52:23PM +0200, Linus Walleij wrote:
> > On Wed, Apr 18, 2012 at 2:28 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > 
> > > Currently Dong Aisheng is working on i.MX6, we have i.MX31, i.MX35,
> > > i.MX51 and i.MX53 enabled in the same defconfig. Waiting for all
> > > machines turn over at once to pinctrl is illusionary. We have to make
> > > drivers work with and without pinctrl. We have a bunch of bad choices:
> > >
> > > - create a dummy pinctrl for all boards which do not have real pinmux
> > >  support
> > 
> > Viable compromise.
> > 
> > > - ignore pinctrl_request errors in drivers.
> > 
> > Ugh. Not good.
> > 
> > > - generate and return a dummy pinctrl in the core if no real pinctrl is
> > >  found.
> > >
> > > (replace pinctrl with regulators or clocks, it's the same situation, and
> > > it's not only i.MX specific)
> > 
> > Since we have dummy regulators, we should not break the design
> > pattern creating more confusion.
> > 
> > Stephen can you live with dummy pinctrl handles emitted by the
> > core, if explictly enabled by a Kconfig option?
> 
> I'd rather not make it a Kconfig option but a runtime option. With a
> Kconfig option we can only chose in the defconfigs whether it won't
> work on some boards or it will hide pinctrl errors on all other boards.
> 
> Create a pinctrl_provide_dummies() functions which boards can call when
> they do not have pinctrl support.
> 
I think this is a feasible method and do better than Kconfig but it also
needs more changes.

>From a long term view all SoC may migrate to pinctrl subsystem, we first need
to change all board files that without pinctrl support to call this function
although just for enable pinctrl for one of them and finally we need remove
it again. (For imx, maybe more than 10 files and double if with dt enabled).
I'm not sure it's worth.

Turn on pinctrl debug information will tell us which devices are using
dummy state.

Regards
Dong Aisheng

