Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0JLPvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:01 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52727 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757609Ab0JLPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:50:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hWcL94yM/+yNMHfYEKn2EiYJr8qQfEU4U4JVRcU3KPOy7k42N3tNRb4LnLc3A5lS9cv1e8bHb6fxi3rxkc+Y7luXapTbCZUmL+VxSyRD/UkwJVgxvfyXtmsKta8gmxkq;
Date: Tue, 12 Oct 2010 08:54:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
        xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org
Subject: Re: [PATCH 13/23] x86/PCI: make sure _PAGE_IOMAP it set on pci
 mappings
Message-ID: <20101012085422.04b4e1c9@jbarnes-desktop>
In-Reply-To: <1286898271-32018-14-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
	<1286898271-32018-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 11:44:21 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> When mapping pci space via /sys or /proc, make sure we're really
> doing a hardware mapping by setting _PAGE_IOMAP.
> 
> [ Impact: bugfix; make PCI mappings map the right pages ]
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> Cc: x86@kernel.org
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  arch/x86/pci/i386.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> index 5525309..8379c2c 100644
> --- a/arch/x86/pci/i386.c
> +++ b/arch/x86/pci/i386.c
> @@ -311,6 +311,8 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
>  		 */
>  		prot |= _PAGE_CACHE_UC_MINUS;
>  
> +	prot |= _PAGE_IOMAP;	/* creating a mapping for IO */
> +
>  	vma->vm_page_prot = __pgprot(prot);
>  
>  	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,

Looks fine.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
