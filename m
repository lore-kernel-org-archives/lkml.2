Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1LTIt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:49:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1LTItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:49:24 -0500
Message-ID: <1324370959.22797.3.camel@lappy>
Subject: Re: [PATCH 1/2] kvm: Remove ability to assign a device without
 iommu support
From: Sasha Levin <levinsasha928@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Tue, 20 Dec 2011 10:49:19 +0200
In-Reply-To: <20111220031947.11829.66292.stgit@bling.home>
References: <20111220030826.11829.9141.stgit@bling.home>
	 <20111220031947.11829.66292.stgit@bling.home>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 20:19 -0700, Alex Williamson wrote:
> This option has no users and it exposes a security hole that we
> can allow devices to be assigned without iommu protection.  Make
> KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  virt/kvm/assigned-dev.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 3ad0925..a251a28 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -487,6 +487,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
>  	struct kvm_assigned_dev_kernel *match;
>  	struct pci_dev *dev;
>  
> +	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
> +		return -EINVAL;

Could we just drop KVM_DEV_ASSIGN_ENABLE_IOMMU and do it by default?
calling KVM_ASSIGN_PCI_DEVICE without that flag set it pretty
meaningless.

-- 

Sasha.

