Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab2FFJbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:31:11 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:2599 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713Ab2FFJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:31:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -13
X-BigFish: VS-13(zzbb2dI9371I168aJ1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 6 Jun 2012 17:31:42 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>,
        Matthew McClintock <msm@freescale.com>
Subject: Re: [PATCH v5 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120606093142.GA23505@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <4FC8E250.9090000@freescale.com>
 <20120605090831.GA21929@localhost.localdomain>
 <4FCE2ECD.4050107@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCE2ECD.4050107@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:07:41AM -0500, Scott Wood wrote:
> On 06/05/2012 04:08 AM, Zhao Chenhui wrote:
> > On Fri, Jun 01, 2012 at 10:40:00AM -0500, Scott Wood wrote:
> >> I know you say this is for dual-core chips only, but it would be nice if
> >> you'd write this in a way that doesn't assume that (even if the
> >> corenet-specific timebase freezing comes later).
> > 
> > At this point, I have not thought about how to implement the cornet-specific timebase freezing.
> 
> I wasn't asking you to.  I was asking you to not have logic that breaks
> with more than 2 CPUs.

These routines only called in the dual-core case. 

> 
> >> Do we need an isync after setting the timebase, to ensure it's happened
> >> before we enable the timebase?  Likewise, do we need a readback after
> >> disabling the timebase to ensure it's disabled before we read the
> >> timebase in give_timebase?
> > 
> > I checked the e500 core manual (Chapter 2.16 Synchronization Requirements for SPRs).
> > Only some SPR registers need an isync. The timebase registers do not.
> 
> I don't trust that, and the consequences of having the sync be imperfect
> are too unpleasant to chance it.
> 
> > I did a readback in mpc85xx_timebase_freeze().
> 
> Sorry, missed that somehow.
> 
> >>> +#ifdef CONFIG_KEXEC
> >>> +	np = of_find_matching_node(NULL, guts_ids);
> >>> +	if (np) {
> >>> +		guts = of_iomap(np, 0);
> >>> +		smp_85xx_ops.give_timebase = mpc85xx_give_timebase;
> >>> +		smp_85xx_ops.take_timebase = mpc85xx_take_timebase;
> >>> +		of_node_put(np);
> >>> +	} else {
> >>> +		smp_85xx_ops.give_timebase = smp_generic_give_timebase;
> >>> +		smp_85xx_ops.take_timebase = smp_generic_take_timebase;
> >>> +	}
> >>
> >> Do not use smp_generic_give/take_timebase, ever.  If you don't have the
> >> guts node, then just assume the timebase is already synced.
> >>
> >> -Scott
> > 
> > smp_generic_give/take_timebase is the default in KEXEC before.
> 
> That was a mistake.
> 
> > If do not set them, it may make KEXEC fail on other platforms.
> 
> What platforms?
> 
> -Scott

Such as P4080, P3041, etc.

-Chenhui


