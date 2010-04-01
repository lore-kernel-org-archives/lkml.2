Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0DAQam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:30:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab0DAQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:30:26 -0400
Message-ID: <4BB462B5.1030402@redhat.com>
Date: Thu, 01 Apr 2010 12:09:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com>
In-Reply-To: <201003311708.38961.pugs@lyon-about.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 03:08 AM, Tom Lyon wrote:
> uio_pci_generic has previously been discussed on the KVM list, but this patch
> has nothing to do with KVM, so it is also going to LKML.
>    

(needs to go to lkml even if it was for kvm)

> The point of this patch is to beef up the uio_pci_generic driver so that a
> non-privileged user process can run a user level driver for most PCIe
> devices. This can only be safe if there is an IOMMU in the system with
> per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if there is
> no IOMMU.
>
> Specifically, I seek to allow low-latency user level network drivers (non
> tcp/ip) which directly access SR-IOV style virtual network adapters, for use
> with packages such as OpenMPI.
>
> Key areas of change:
> - ioctl extensions to allow registration and dma mapping of memory regions,
> with lock accounting
> - support for mmu notifier driven de-mapping
>    

Note that current iommus/devices don't support restart-on-fault dma, so 
userspace drivers will have to lock memory so that it is not swapped 
out.  I don't think this prevents page migration, though.

> - support for MSI and MSI-X interrupts (the intel 82599 VFs support only
> MSI-X)
>    

How does a userspace program receive those interrupts?

> - allowing interrupt enabling and device register mapping all
> through /dev/uio* so that  permissions may be granted just by chmod
> on /dev/uio*
>    

That was always broken with the sysfs interface.

-- 
error compiling committee.c: too many arguments to function

