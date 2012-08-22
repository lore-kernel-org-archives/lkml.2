Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2HVKIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:08:02 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54143 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2HVKIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:08:00 -0400
Date: Wed, 22 Aug 2012 12:07:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v2 2/2] x86/pat: Avoid contention on cpa_lock if possible
Message-ID: <20120822100755.GA26323@gmail.com>
References: <1344445299-22142-1-git-send-email-ido@wizery.com>
 <1344445299-22142-2-git-send-email-ido@wizery.com>
 <20120822084702.GA21764@gmail.com>
 <20120822095316.GA16110@WorkStation.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822095316.GA16110@WorkStation.localnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> Hi Ingo,
> 
> On Wed, Aug 22, 2012 at 10:47:02AM +0200, Ingo Molnar wrote:
> > 
> > * Ido Yariv <ido@wizery.com> wrote:
> > 
> > > vSMP Foundation does not require to serialize CPA by guaranteeing that
> > > the most recent TLB entry will always be used.
> > > 
> > > To avoid needless contention on cpa_lock, do not lock/unlock it if it
> > > isn't necessary.
> > > 
> > > Based on work by Shai Fultheim <shai@scalemp.com>.
> > > 
> > > Signed-off-by: Ido Yariv <ido@wizery.com>
> > > Acked-by: Shai Fultheim <shai@scalemp.com>
> > > ---
> > > Changes from v1:
> > > - Use a synthetic CPUID bit and a use static_cpu_has() as suggested by
> > >   H. Peter Avnin
> > > 
> > >  arch/x86/include/asm/cpufeature.h |    1 +
> > >  arch/x86/kernel/vsmp_64.c         |   10 ++++++++++
> > >  arch/x86/mm/pageattr.c            |   30 +++++++++++++++++++++---------
> > >  3 files changed, 32 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> > > index 6b7ee5f..92303a0 100644
> > > --- a/arch/x86/include/asm/cpufeature.h
> > > +++ b/arch/x86/include/asm/cpufeature.h
> > > @@ -97,6 +97,7 @@
> > >  #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
> > >  #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
> > >  #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
> > > +#define X86_FEATURE_NO_CPA_LOCK	(3*32+29) /* Serializing cpa is not required */
> > 
> > Patch looks mostly good, but could we please use some more 
> > hardware-ish name, instead of referring to a kernel lock?
> 
> Sure thing. How about X86_FEATURE_TLB_RELIABLE?

Yeah, something like that. Maybe hpa can think of something 
better?

Thanks,

	Ingo
