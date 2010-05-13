Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab0EMWGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0EMWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:06:03 -0400
Date: Thu, 13 May 2010 15:06:01 -0700
From: Chris Wright <chrisw@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com
Subject: Re: [PATCH] kvm: remove CAP_SYS_RAWIO requirement from
 kvm_vm_ioctl_assign_irq
Message-ID: <20100513220601.GH30483@x200.localdomain>
References: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512134619.30602.63792.stgit@virtlab9.virt.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> Remove this check in an effort to allow kvm guests to run without
> root privileges.  This capability check doesn't seem to add any
> security since the device needs to have already been added via the
> assign device ioctl and the io actually occurs through the pci
> sysfs interface.

Right, so irq resource allocation can't be directly abused (by calling
this ioctl out of order, for example) because the device must be assigned
first via kvm_vm_ioctl_assign_device().  My only concern isn't with this
patch per-se, but the exising kvm_vm_ioctl_assign_device().

thanks,
-chris
