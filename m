Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab0EMXOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab0EMXOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:14:17 -0400
Subject: Re: [PATCH] kvm: remove CAP_SYS_RAWIO requirement from
 kvm_vm_ioctl_assign_irq
From: Alex Williamson <alex.williamson@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100513220601.GH30483@x200.localdomain>
References: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
	 <20100513220601.GH30483@x200.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 16:22:45 -0600
Message-ID: <1273789365.2682.137.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 15:06 -0700, Chris Wright wrote:
> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > Remove this check in an effort to allow kvm guests to run without
> > root privileges.  This capability check doesn't seem to add any
> > security since the device needs to have already been added via the
> > assign device ioctl and the io actually occurs through the pci
> > sysfs interface.
> 
> Right, so irq resource allocation can't be directly abused (by calling
> this ioctl out of order, for example) because the device must be assigned
> first via kvm_vm_ioctl_assign_device().  My only concern isn't with this
> patch per-se, but the exising kvm_vm_ioctl_assign_device().

Yep, I agree.  How do we decide the caller of the assign device ioctl
has sufficient rights to the device without introducing another
capabilities check?  We won't get far if the resources are already
claimed by a running driver, but we don't necessarily want anyone
with /dev/kvm rights to be able to grab the remaining devices in the
system.

Alex

