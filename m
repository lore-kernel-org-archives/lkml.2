Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1LHIcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:32:15 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:12905 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1LHIcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:32:14 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9355864"
Subject: Re: [Xen-devel] [PATCH 4/4] xen/privcmd: Remove unused support for
 arch specific privcmp mmap
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 8 Dec 2011 08:32:13 +0000
In-Reply-To: <1323292396-19523-5-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
	 <1323292396-19523-5-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323333133.2969.55.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> ---

You've forgotten the S-o-b for this patch.

Once upon a time this was used by the ia64 privcmd support[0] but since
no one appears to be working on ia64 dom0 support for upstream I'm not
sure if this is an issue or not. I lean towards "not", this can always
be put back as necessary.

Acked-by: Ian Campbell <ian.campbell@citrix.com>

[0]
http://xenbits.xen.org/hg/linux-2.6.18-xen.hg/file/bffd07392da5/arch/ia64/xen/hypervisor.c#l659
http://xenbits.xen.org/hg/linux-2.6.18-xen.hg/file/bffd07392da5/include/asm-ia64/hypervisor.h#l132

>  drivers/xen/privcmd.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
> index 863fbd0..c13d26a 100644
> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -365,7 +365,6 @@ static long privcmd_ioctl(struct file *file,
>  	return ret;
>  }
>  
> -#ifndef HAVE_ARCH_PRIVCMD_MMAP
>  static int privcmd_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	printk(KERN_DEBUG "privcmd_fault: vma=%p %lx-%lx, pgoff=%lx, uv=%p\n",
> @@ -398,7 +397,6 @@ static int privcmd_enforce_singleshot_mapping(struct vm_area_struct *vma)
>  {
>  	return (xchg(&vma->vm_private_data, (void *)1) == NULL);
>  }
> -#endif
>  
>  const struct file_operations xen_privcmd_fops = {
>  	.owner = THIS_MODULE,


