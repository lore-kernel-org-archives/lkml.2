Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab0JIKct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 06:32:49 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56530 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497Ab0JIKcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 06:32:46 -0400
Date: Sat, 9 Oct 2010 11:32:43 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/7] ARM: oprofile: Move non-ARM code into separate
 init/exit
Message-ID: <20101009103242.GA17466@console-pimps.org>
References: <cover.1286584677.git.matt@console-pimps.org>
 <0de9eda11dbfe9c21348da07b57f04f35cd9effc.1286584677.git.matt@console-pimps.org>
 <20101009012647.GM13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101009012647.GM13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 03:26:47AM +0200, Robert Richter wrote:
> On 08.10.10 20:46:20, Matt Fleming wrote:
> > In preparation for moving the majority of this oprofile code into an
> > architecture-neutral place separate the architecture-independent code
> > into oprofile_perf_init() and oprofile_perf_exit().
> > 
> > Signed-off-by: Matt Fleming <matt@console-pimps.org>
> > Tested-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  arch/arm/oprofile/common.c |   27 +++++++++++++++++++--------
> >  1 files changed, 19 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > index fd6e323..8718311 100644
> > --- a/arch/arm/oprofile/common.c
> > +++ b/arch/arm/oprofile/common.c
> > @@ -349,7 +349,7 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
> >  		tail = user_backtrace(tail);
> >  }
> >  
> > -int __init oprofile_arch_init(struct oprofile_operations *ops)
> > +int __init oprofile_perf_init(struct oprofile_operations *ops)
> >  {
> >  	int cpu, ret = 0;
> >  
> > @@ -387,12 +387,11 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
> >  		}
> >  	}
> >  
> > -	ops->backtrace		= arm_backtrace;
> > -	ops->create_files	= op_arm_create_files;
> > -	ops->setup		= op_arm_setup;
> > -	ops->start		= op_arm_start;
> > -	ops->stop		= op_arm_stop;
> > -	ops->shutdown		= op_arm_stop;
> > +	ops->create_files	= oprofile_perf_create_files;
> > +	ops->setup		= oprofile_perf_setup;
> > +	ops->start		= oprofile_perf_start;
> > +	ops->stop		= oprofile_perf_stop;
> > +	ops->shutdown		= oprofile_perf_stop;
> 
> There is a compile breakage caused by patch #4. Will move the renames
> to patch #4 when applying the patch.

Sorry, I don't know how this happened. These renames were originally in
patch #4 but seem to have moved into #5 when I was reshuffling stuff.
