Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab2GCQRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:17:09 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:29709 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab2GCQRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:17:08 -0400
X-IronPort-AV: E=Sophos;i="4.77,516,1336348800"; 
   d="scan'208";a="13349227"
Message-ID: <1341332224.25743.4.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 2/4] xen/perf: Define .glob for the
 different hypercalls.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 3 Jul 2012 17:17:04 +0100
In-Reply-To: <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
	 <1341330038-21686-3-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 16:40 +0100, Konrad Rzeszutek Wilk wrote:
> This allows us in perf to have this:
> 
>  99.67%  [kernel]             [k] xen_hypercall_sched_op
>   0.11%  [kernel]             [k] xen_hypercall_xen_version
> 
> instead of the borring ever-encompassing:
> 
>  99.13%  [kernel]              [k] hypercall_page
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I don't suppose it would be possible to automate this somehow would it?
Perhaps a small perl snippet consuming the output of 
        grep ^\#define.__HYPERVISOR_ include/xen/interface/xen.h
?

> ---
>  arch/x86/xen/xen-head.S |  102 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 100 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index aaa7291..f6ba51d 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -28,9 +28,107 @@ ENTRY(startup_xen)
>  	__FINIT
>  
>  .pushsection .text
> -	.align PAGE_SIZE
> +	.balign PAGE_SIZE
>  ENTRY(hypercall_page)
> -	.skip PAGE_SIZE
> +ENTRY(xen_hypercall_set_trap_table)
> +	.skip 32
> +ENTRY(xen_hypercall_mmu_update)
> +	.skip 32
> +ENTRY(xen_hypercall_set_gdt)
> +	.skip 32
> +ENTRY(xen_hypercall_stack_switch)
> +	.skip 32
> +ENTRY(xen_hypercall_set_callbacks)
> +	.skip 32
> +ENTRY(xen_hypercall_fpu_taskswitch)
> +	.skip 32
> +ENTRY(xen_hypercall_sched_op_compat)
> +	.skip 32
> +ENTRY(xen_hypercall_platform_op)
> +	.skip 32
> +ENTRY(xen_hypercall_set_debugreg)
> +	.skip 32
> +ENTRY(xen_hypercall_get_debugreg)
> +	.skip 32
> +ENTRY(xen_hypercall_update_descriptor)
> +	.skip 32
> +ENTRY(xen_hypercall_ni)
> +	.skip 32
> +ENTRY(xen_hypercall_memory_op)
> +	.skip 32
> +ENTRY(xen_hypercall_multicall)
> +	.skip 32
> +ENTRY(xen_hypercall_update_va_mapping)
> +	.skip 32
> +ENTRY(xen_hypercall_set_timer_op)
> +	.skip 32
> +ENTRY(xen_hypercall_event_channel_op_compat)
> +	.skip 32
> +ENTRY(xen_hypercall_xen_version)
> +	.skip 32
> +ENTRY(xen_hypercall_console_io)
> +	.skip 32
> +ENTRY(xen_hypercall_physdev_op_compat)
> +	.skip 32
> +ENTRY(xen_hypercall_grant_table_op)
> +	.skip 32
> +ENTRY(xen_hypercall_vm_assist)
> +	.skip 32
> +ENTRY(xen_hypercall_update_va_mapping_otherdomain)
> +	.skip 32
> +ENTRY(xen_hypercall_iret)
> +	.skip 32
> +ENTRY(xen_hypercall_vcpu_op)
> +	.skip 32
> +ENTRY(xen_hypercall_set_segment_base)
> +	.skip 32
> +ENTRY(xen_hypercall_mmuext_op)
> +	.skip 32
> +ENTRY(xen_hypercall_xsm_op)
> +	.skip 32
> +ENTRY(xen_hypercall_nmi_op)
> +	.skip 32
> +ENTRY(xen_hypercall_sched_op)
> +	.skip 32
> +ENTRY(xen_hypercall_callback_op)
> +	.skip 32
> +ENTRY(xen_hypercall_xenoprof_op)
> +	.skip 32
> +ENTRY(xen_hypercall_event_channel_op)
> +	.skip 32
> +ENTRY(xen_hypercall_physdev_op)
> +	.skip 32
> +ENTRY(xen_hypercall_hvm_op)
> +	.skip 32
> +ENTRY(xen_hypercall_sysctl)
> +	.skip 32
> +ENTRY(xen_hypercall_domctl)
> +	.skip 32
> +ENTRY(xen_hypercall_kexec_op)
> +	.skip 32
> +ENTRY(xen_hypercall_tmem_op) /* 38 */
> +	.skip 32
> +ENTRY(xen_hypercall_rsvr)
> +	.skip 320
> +ENTRY(xen_hypercall_mca) /* 48 */
> +	.skip 32
> +ENTRY(xen_hypercall_arch_1)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_2)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_3)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_4)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_5)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_6)
> +	.skip 32
> +ENTRY(xen_hypercall_arch_7)
> +	.skip 32
> +ENTRY(xen_hypercall_other)
> +	.skip 2272
> +
>  .popsection
>  
>  	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")


