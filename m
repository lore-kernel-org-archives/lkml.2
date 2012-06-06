Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2FFJ7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:59:39 -0400
Received: from [65.55.88.11] ([65.55.88.11]:47922 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab2FFJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:59:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 6 Jun 2012 17:59:10 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 2/5] powerpc/85xx: add HOTPLUG_CPU support
Message-ID: <20120606095910.GB23505@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com>
 <4FC933BF.1020901@freescale.com>
 <20120604110444.GA20676@localhost.localdomain>
 <4FCCE32F.1060301@freescale.com>
 <20120605111823.GB22427@localhost.localdomain>
 <4FCE30B8.2070902@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FCE30B8.2070902@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 11:15:52AM -0500, Scott Wood wrote:
> On 06/05/2012 06:18 AM, Zhao Chenhui wrote:
> > On Mon, Jun 04, 2012 at 11:32:47AM -0500, Scott Wood wrote:
> >> On 06/04/2012 06:04 AM, Zhao Chenhui wrote:
> >>> On Fri, Jun 01, 2012 at 04:27:27PM -0500, Scott Wood wrote:
> >>>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> >>>>> -#ifdef CONFIG_KEXEC
> >>>>> +#if defined(CONFIG_KEXEC) || defined(CONFIG_HOTPLUG_CPU)
> >>>>
> >>>> Let's not grow lists like this.  Is there any harm in building it
> >>>> unconditionally?
> >>>>
> >>>> -Scott
> >>>
> >>> We need this ifdef. We only set give_timebase/take_timebase
> >>> when CONFIG_KEXEC or CONFIG_HOTPLUG_CPU is defined.
> >>
> >> If we really need this to be a compile-time decision, make a new symbol
> >> for it, but I really think this should be decided at runtime.  Just
> >> because we have kexec or hotplug support enabled doesn't mean that's
> >> actually what we're doing at the moment.
> >>
> >> -Scott
> > 
> > If user does not enable kexec or hotplug, these codes are redundant.
> > So use CONFIG_KEXEC and CONFIG_HOTPLUG_CPU to gard them.
> 
> My point is that these lists tend to grow and be a maintenance pain.
> For small things it's often better to not worry about saving a few
> bytes.  For larger things that need to be conditional, define a new
> symbol rather than growing ORed lists like this.
> 
> -Scott

I agree with you in principle. But there are only two config options
in this patch, and it is unlikely to grow. 

-Chenhui

