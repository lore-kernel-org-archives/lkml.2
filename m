Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318Ab2I1QCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:02:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33082 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243Ab2I1QCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:02:01 -0400
Date: Fri, 28 Sep 2012 12:10:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: andrew.cooper3@citrix.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 03/11] xen: Introduce architecture independent data for
 kexec/kdump
Message-ID: <20120928161016.GB16262@localhost.localdomain>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 08:06:30PM +0200, Daniel Kiper wrote:
> Introduce architecture independent constants and structures

Don't you mean 'dependent constants'?

> required by Xen kexec/kdump implementation.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  include/xen/interface/xen.h |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
> index 0801468..ac19f9e 100644
> --- a/include/xen/interface/xen.h
> +++ b/include/xen/interface/xen.h
> @@ -58,6 +58,7 @@
>  #define __HYPERVISOR_event_channel_op     32
>  #define __HYPERVISOR_physdev_op           33
>  #define __HYPERVISOR_hvm_op               34
> +#define __HYPERVISOR_kexec_op             37
>  #define __HYPERVISOR_tmem_op              38
>  
>  /* Architecture-specific hypercall definitions. */
> @@ -232,7 +233,39 @@ DEFINE_GUEST_HANDLE_STRUCT(mmuext_op);
>  #define VMASST_TYPE_pae_extended_cr3     3
>  #define MAX_VMASST_TYPE 3
>  
> +/*
> + * Commands to HYPERVISOR_kexec_op().
> + */
> +#define KEXEC_CMD_kexec			0
> +#define KEXEC_CMD_kexec_load		1
> +#define KEXEC_CMD_kexec_unload		2
> +#define KEXEC_CMD_kexec_get_range	3
> +
> +/*
> + * Memory ranges for kdump (utilized by HYPERVISOR_kexec_op()).
> + */
> +#define KEXEC_RANGE_MA_CRASH		0
> +#define KEXEC_RANGE_MA_XEN		1
> +#define KEXEC_RANGE_MA_CPU		2
> +#define KEXEC_RANGE_MA_XENHEAP		3
> +#define KEXEC_RANGE_MA_BOOT_PARAM	4
> +#define KEXEC_RANGE_MA_EFI_MEMMAP	5
> +#define KEXEC_RANGE_MA_VMCOREINFO	6
> +
>  #ifndef __ASSEMBLY__
> +struct xen_kexec_exec {
> +	int type;
> +};
> +
> +struct xen_kexec_range {
> +	int range;
> +	int nr;
> +	unsigned long size;
> +	unsigned long start;
> +};

Might want to include an little blurb saying what we expect
in case of running a 32-bit domain on a 64-bit hypervisor
where the start might be past 4GB?

> +
> +extern unsigned long xen_vmcoreinfo_maddr;
> +extern unsigned long xen_vmcoreinfo_max_size;
>  
>  typedef uint16_t domid_t;
>  
> -- 
> 1.5.6.5
