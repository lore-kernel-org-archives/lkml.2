Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2DCNYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:24:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39042 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2DCNYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:24:30 -0400
Date: Tue, 3 Apr 2012 09:19:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/gntdev: do not set VM_PFNMAP
Message-ID: <20120403131947.GC12464@phenom.dumpdata.com>
References: <1333452302-5749-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333452302-5749-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F7AFA09.0084,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 12:25:02PM +0100, Stefano Stabellini wrote:
> Since when we are using the m2p_override it is not true anymore that the
        ^^^^ - get rid of that.
> mmap'ed area doesn't have corresponsing struct pages.

That reads to me as !!do struct page. Which comes out as:

"m2p_override_* API the mmap-ed are have corresponding struct pages' ?


> 
> Removing the VM_PFNMAP flag makes get_user_pages work on the mmap'ed user vma.
> An example test case would be using a Xen userspace block backend
> (QDISK) on a file on NFS using O_DIRECT.
> 
> The patch should be backported back to 2.6.38.

Add CC: stable@kernel.org then. But does this patch depend on other
patches?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/gntdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 99d8151..1ffd03b 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -722,7 +722,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
>  	vma->vm_flags |= VM_RESERVED|VM_DONTEXPAND;
>  
>  	if (use_ptemod)
> -		vma->vm_flags |= VM_DONTCOPY|VM_PFNMAP;
> +		vma->vm_flags |= VM_DONTCOPY;
>  
>  	vma->vm_private_data = map;
>  
> -- 
> 1.7.2.5
