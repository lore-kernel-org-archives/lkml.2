Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab2FGEGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:06:37 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:14158
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753Ab2FGEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:06:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Thu, 7 Jun 2012 12:07:01 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>,
        Matthew McClintock <msm@freescale.com>
Subject: Re: [PATCH v5 1/5] powerpc/85xx: implement hardware timebase sync
Message-ID: <20120607040701.GA15965@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <4FC8E250.9090000@freescale.com>
 <20120605090831.GA21929@localhost.localdomain>
 <4FCE2ECD.4050107@freescale.com>
 <20120606093142.GA23505@localhost.localdomain>
 <4FCFA0C8.9090800@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCFA0C8.9090800@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 01:26:16PM -0500, Scott Wood wrote:
> On 06/06/2012 04:31 AM, Zhao Chenhui wrote:
> > On Tue, Jun 05, 2012 at 11:07:41AM -0500, Scott Wood wrote:
> >> On 06/05/2012 04:08 AM, Zhao Chenhui wrote:
> >>> On Fri, Jun 01, 2012 at 10:40:00AM -0500, Scott Wood wrote:
> >>>> I know you say this is for dual-core chips only, but it would be nice if
> >>>> you'd write this in a way that doesn't assume that (even if the
> >>>> corenet-specific timebase freezing comes later).
> >>>
> >>> At this point, I have not thought about how to implement the cornet-specific timebase freezing.
> >>
> >> I wasn't asking you to.  I was asking you to not have logic that breaks
> >> with more than 2 CPUs.
> > 
> > These routines only called in the dual-core case. 
> 
> Come on, you know we have chips with more than two cores.  Why design
> such a limitation into it, just because you're not personally interested
> in supporting anything but e500v2?
> 
> Is it so hard to make it work for an arbitrary number of cores?
> 
> >>> If do not set them, it may make KEXEC fail on other platforms.
> >>
> >> What platforms?
> > 
> > Such as P4080, P3041, etc.
> 
> So we need to wait for corenet timebase sync before we stop causing
> problems in virtualization, simulators, etc. if a kernel has kexec or
> cpu hotplug enabled (whether used or not)?
> 
> Can you at least make sure we're actually in a kexec/hotplug scenario at
> runtime?
> 
> Or just implement corenet timebase sync -- it's not that different.
> 
> -Scott

We also work on the corenet timebase sync. Our plan is first the dual-core case,
then the case of more than 2 cores. We will submit the corenet timebase sync patch soon.

-Chenhui

