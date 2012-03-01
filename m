Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2CADEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:04:04 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:14683
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932134Ab2CADD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:03:59 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz9371I1432N1418M98dK1447Mzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 1 Mar 2012 11:09:32 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 4/6] pinctrl: API changes to support multiple states
 per device
Message-ID: <20120301030931.GA27020@shlinux2.ap.freescale.net>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-5-git-send-email-swarren@nvidia.com>
 <20120229064633.GA14703@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BDDF207C@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF207C@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 09:22:42AM -0800, Stephen Warren wrote:
> Dong Aisheng wrote at Tuesday, February 28, 2012 11:47 PM:
.....
> > > +	if (p->state) {
> > > +		/*
> > > +		 * The set of groups with a mux configuration in the old state
> > > +		 * may not be identical to the set of groups with a mux setting
> > > +		 * in the new state. While this might be unusual, it's entirely
> > > +		 * possible for the "user"-supplied mapping table to be written
> > > +		 * that way. For each group that was configured in the old state
> > > +		 * but not in the new state, this code puts that group into a
> > > +		 * safe/disabled state.
> >
> > It means the old state function of some groups may not have been disabled before
> > enabling the new function mode.
> > May it be a little error-prone?
> > Maybe we can not depend on user to disable a function before enable another for
> > a group when doing pinmux_enable_setting considering they may be different
> > registers.
> 
> The idea here is that there are two cases:
> 
> 1) (hopefully the typical case)
> 
> Group X HAS a mux function set in OLD state
> Group X HAS a mux function set in NEW state
> 
> In this case, we simply call pinmux_enable_setting(new state).
> 
> We do this so that we can transition directly from the old state to the
> new state without going through any artificial intermediate states, to
> make the mux switching as glitchless as possible.
> 
> If the HW has some restriction where it has to operate like:
> 
> Old state -> idle -> new state
> 
> Rather than:
> 
> Old state -> new state
> 
> Then I think that should be taken care of within the individual driver;
> given most mux selection is just a register field that feeds into a simple
> signal mux in HW, such a requirement seems pretty unlikely to me, but you
> never know.
> 
I thought before that the mux function for GROUP X in OLD state may be set
in register A while mux function in NEW state may be set in register B.
So before setting new state function, user should disable old state function
(clear register A)first. (Maybe i thought too far)

But now i realize that you're correct, this can be handled in individual driver
for different HW requirement.

> 2)
> 
> Group X HAS a mux function set in OLD state
> Group X DOES NOT have a mux function set in NEW state
> 
> In this case, we call pinmux_disable_setting(old state) to ensure that
> the pin is put into some idle state that can't interfere with any other
> pin.
> 
Thanks for the detailed clarification.

Regards
Dong Aisheng

