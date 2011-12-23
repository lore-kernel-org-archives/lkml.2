Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1LWLin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab1LWLim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:38:42 -0500
Date: Fri, 23 Dec 2011 09:03:11 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, levinsasha928@gmail.com
Subject: Re: [PATCH v3 0/2] kvm: Lock down device assignment
Message-ID: <20111223110311.GC24308@amt.cnet>
References: <20111221045636.5773.11289.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221045636.5773.11289.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 09:58:57PM -0700, Alex Williamson wrote:
> v2: Update API documentation for each patch
> v3: Incorporate Sasha's comments: kobject path, separate func, and CONFIG_SYSFS
> 
> Two patches to try to better secure the device assignment ioctl.
> This firt patch makes KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory
> option when assigning a device.  I don't believe we have any
> users of this option, so I think we can skip any deprecation
> period, especially since it's existence is rather dangerous.
> 
> The second patch introduces some file permission checking that Avi
> suggested.  If a user has been granted read/write permission to
> the PCI sysfs BAR resource files, this is a good indication that
> they have access to the device.  We can't call sys_faccessat
> directly (not exported), but the important bits are self contained
> enough to include directly.  This still works with sudo and libvirt
> usage, the latter already grants qemu permission to these files.
> Thanks,
> 
> Alex
> 
> ---
> 
> Alex Williamson (2):
>       kvm: Device assignment permission checks
>       kvm: Remove ability to assign a device without iommu support

Applied, thanks.

