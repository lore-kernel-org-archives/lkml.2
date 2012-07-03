Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2GCRrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:47:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40968 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2GCRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:47:06 -0400
Date: Tue, 3 Jul 2012 13:38:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/4] xen/perf: Define .glob for the different
 hypercalls.
Message-ID: <20120703173827.GB24259@phenom.dumpdata.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
 <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
 <4FF334E9020000780008D610@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF334E9020000780008D610@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 05:07:37PM +0100, Jan Beulich wrote:
> >>> On 03.07.12 at 17:40, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > This allows us in perf to have this:
> > 
> >  99.67%  [kernel]             [k] xen_hypercall_sched_op
> >   0.11%  [kernel]             [k] xen_hypercall_xen_version
> > 
> > instead of the borring ever-encompassing:
> > 
> >  99.13%  [kernel]              [k] hypercall_page
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/xen-head.S |  102 
> > ++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 100 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index aaa7291..f6ba51d 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -28,9 +28,107 @@ ENTRY(startup_xen)
> >  	__FINIT
> >  
> >  .pushsection .text
> > -	.align PAGE_SIZE
> > +	.balign PAGE_SIZE
> >  ENTRY(hypercall_page)
> > -	.skip PAGE_SIZE
> > +ENTRY(xen_hypercall_set_trap_table)
> > +	.skip 32
> > +ENTRY(xen_hypercall_mmu_update)
> > +	.skip 32
> > +ENTRY(xen_hypercall_set_gdt)
> > +	.skip 32
> > +ENTRY(xen_hypercall_stack_switch)
> > +	.skip 32
> > +ENTRY(xen_hypercall_set_callbacks)
> > +	.skip 32
> > +ENTRY(xen_hypercall_fpu_taskswitch)
> > +	.skip 32
> > +ENTRY(xen_hypercall_sched_op_compat)
> > +	.skip 32
> > +ENTRY(xen_hypercall_platform_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_set_debugreg)
> > +	.skip 32
> > +ENTRY(xen_hypercall_get_debugreg)
> > +	.skip 32
> > +ENTRY(xen_hypercall_update_descriptor)
> > +	.skip 32
> > +ENTRY(xen_hypercall_ni)
> > +	.skip 32
> > +ENTRY(xen_hypercall_memory_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_multicall)
> > +	.skip 32
> > +ENTRY(xen_hypercall_update_va_mapping)
> > +	.skip 32
> > +ENTRY(xen_hypercall_set_timer_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_event_channel_op_compat)
> > +	.skip 32
> > +ENTRY(xen_hypercall_xen_version)
> > +	.skip 32
> > +ENTRY(xen_hypercall_console_io)
> > +	.skip 32
> > +ENTRY(xen_hypercall_physdev_op_compat)
> > +	.skip 32
> > +ENTRY(xen_hypercall_grant_table_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_vm_assist)
> > +	.skip 32
> > +ENTRY(xen_hypercall_update_va_mapping_otherdomain)
> > +	.skip 32
> > +ENTRY(xen_hypercall_iret)
> > +	.skip 32
> > +ENTRY(xen_hypercall_vcpu_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_set_segment_base)
> > +	.skip 32
> > +ENTRY(xen_hypercall_mmuext_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_xsm_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_nmi_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_sched_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_callback_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_xenoprof_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_event_channel_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_physdev_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_hvm_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_sysctl)
> > +	.skip 32
> > +ENTRY(xen_hypercall_domctl)
> > +	.skip 32
> > +ENTRY(xen_hypercall_kexec_op)
> > +	.skip 32
> > +ENTRY(xen_hypercall_tmem_op) /* 38 */
> > +	.skip 32
> > +ENTRY(xen_hypercall_rsvr)
> > +	.skip 320
> > +ENTRY(xen_hypercall_mca) /* 48 */
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_1)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_2)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_3)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_4)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_5)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_6)
> > +	.skip 32
> > +ENTRY(xen_hypercall_arch_7)
> > +	.skip 32
> > +ENTRY(xen_hypercall_other)
> > +	.skip 2272
> 
> May I suggest that you use
> 
> 	.balign PAGE_SIZE
> 
> here again, avoiding the need to adjust the number with every
> future addition at the end?

<nods> Sure thing.
> 
> Jan
> 
> > +
> >  .popsection
> >  
> >  	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
