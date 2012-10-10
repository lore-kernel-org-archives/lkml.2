Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2JJSMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab2JJSMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:12:53 -0400
Date: Wed, 10 Oct 2012 13:51:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH] virt/kvm: change kvm_assign_device() to print return
 value when iommu_attach_device() fails
Message-ID: <20121010165110.GB2506@amt.cnet>
References: <1349742971.2674.75.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349742971.2674.75.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 06:36:11PM -0600, Shuah Khan wrote:
> Change existing kernel error message to include return value from
> iommu_attach_device() when it fails. This will help debug device
> assignment failures more effectively.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  virt/kvm/iommu.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> index 037cb67..18e1e30 100644
> --- a/virt/kvm/iommu.c
> +++ b/virt/kvm/iommu.c
> @@ -168,11 +168,7 @@ int kvm_assign_device(struct kvm *kvm,
>  
>  	r = iommu_attach_device(domain, &pdev->dev);
>  	if (r) {
> -		printk(KERN_ERR "assign device %x:%x:%x.%x failed",
> -			pci_domain_nr(pdev->bus),
> -			pdev->bus->number,
> -			PCI_SLOT(pdev->devfn),
> -			PCI_FUNC(pdev->devfn));
> +		dev_err(&pdev->dev, "kvm assign device failed ret %d", r);
>  		return r;
>  	}

Why removal of domain,bus,slot,func from the message?

