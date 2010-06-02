Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0FBEa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 00:30:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0FBEaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 00:30:24 -0400
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
In-Reply-To: <4C04E0E0.3070006@redhat.com>
References: <20100530121944.GH27611@redhat.com>
	 <4C025999.7080706@redhat.com> <20100530124949.GI27611@redhat.com>
	 <4C0261C1.9090204@redhat.com> <20100530130332.GM27611@redhat.com>
	 <4C026497.8070901@redhat.com> <20100530145309.GO27611@redhat.com>
	 <4C03A285.7060902@redhat.com> <20100531171007.GA6516@redhat.com>
	 <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com>
	 <4C04E0E0.3070006@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:29:47 -0600
Message-ID: <1275452987.16980.24.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 13:28 +0300, Avi Kivity wrote:
> On 06/01/2010 12:55 PM, Michael S. Tsirkin wrote:
> >
> >>   It can't program the iommu.
> >> What
> >> the patch proposes is that userspace tells vfio about the needed
> >> mappings, and vfio programs the iommu.
> >>      
> > There seems to be some misunderstanding.  The userspace interface
> > proposed forces a separate domain per device and forces userspace to
> > repeat iommu programming for each device.  We are better off sharing a
> > domain between devices and programming the iommu once.
> >    
> 
>    iommufd = open(/dev/iommu);
>    ioctl(iommufd, IOMMUFD_ASSIGN_RANGE, ...)
>    ioctl(vfiofd, VFIO_SET_IOMMU, iommufd)

It seems part of the annoyance of the current KVM device assignment is
that we have multiple files open, we mmap here, read there, write over
there, maybe, if it's not emulated.  I quite like Tom's approach that we
have one stop shopping with /dev/vfio<n>, including config space
emulation so each driver doesn't have to try to write their own.  So
continuing with that, shouldn't we be able to add a GET_IOMMU/SET_IOMMU
ioctl to vfio so that after we setup one device we can bind the next to
the same domain?

Alex

