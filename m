Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab1BQUN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:13:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484Ab1BQUNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:13:55 -0500
Message-ID: <4D5D817B.8040609@redhat.com>
Date: Thu, 17 Feb 2011 15:13:47 -0500
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        chrisw@redhat.com
Subject: Re: [PATCH v2 0/2] intel-iommu: Fix domain_ids exhaustion
References: <20110216203204.2979.13203.stgit@s20.home>
In-Reply-To: <20110216203204.2979.13203.stgit@s20.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Williamson wrote:
> When we unbind a device from a driver, we don't properly unlink
> the domain from the iommu, so we never free the domain id it
> was using.  We're typically limited to something like 256 domain
> ids, so a loop of unbinding and rebinding a device can exhaust
> this pretty quickly.  If we're assigning the device to a KVM
> guest, libvirt does exactly this each time the device is removed
> from the host driver or added back.  When we do run out, we oops
> the kernel.  Fix these.
> 
> v2:
> 
> We only want to call domain_exit() for domains automatically created
> via the dma ops path.  VM and SI domains have their own life cycle
> and should not be destroyed here.  With v1, if a device was unbound
> from pci-stub while assigned to a VM, the kernel would oops on the
> next call into iommu ops.
> 
> BTW, should we even be removing the device from the domain in the
> VM domain case?  Drivers and VM domains are (unfortunately) orthogonal
> concepts here with the way KVM is currently wired.  Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       intel-iommu: Fix get_domain_for_dev() error path
>       intel-iommu: Unlink domain from iommu
> 
> 
>  drivers/pci/intel-iommu.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Acked-by: Donald Dutile <ddutile@redhat.com>

