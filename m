Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab2HXSUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:20:18 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18907 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2HXSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:20:13 -0400
Date: Fri, 24 Aug 2012 14:17:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: fix logical error in tlb flushing
Message-ID: <20120824181721.GC15167@konrad-lan.dumpdata.com>
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
 <5037A8E7020000780008A78B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5037A8E7020000780008A78B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 04:16:39PM +0100, Jan Beulich wrote:
> >>> On 24.08.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
> > While TLB_FLUSH_ALL gets passed as 'end' argument to
> > flush_tlb_others(), the Xen code was made to check its 'start'
> > parameter. That may give a incorrect op.cmd to MMUEXT_INVLPG_MULTI
> > instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page can not
> > be flushed from TLB.
> > 
> > This patch fixed this issue.
> > 
> > Reported-by: Jan Beulich <jbeulich@suse.com>
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> Acked-by: Jan Beulich <jbeulich@suse.com>

How can I reproduce this and should this also go to stable@kernel.org?
> 
> > ---
> >  arch/x86/xen/mmu.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> > index b65a761..5141d80 100644
> > --- a/arch/x86/xen/mmu.c
> > +++ b/arch/x86/xen/mmu.c
> > @@ -1283,7 +1283,7 @@ static void xen_flush_tlb_others(const struct cpumask 
> > *cpus,
> >  	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
> >  
> >  	args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
> > -	if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
> > +	if (end != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
> >  		args->op.cmd = MMUEXT_INVLPG_MULTI;
> >  		args->op.arg1.linear_addr = start;
> >  	}
> > -- 
> > 1.7.5.4
> > 
> > .
> 
> 
> 
