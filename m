Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2LNEpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab2LNEpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:45:53 -0500
Message-ID: <1355460351.2229.20.camel@ul30vt.home>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gao <pkill.2012@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Date: Thu, 13 Dec 2012 21:45:51 -0700
In-Reply-To: <CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	 <1355415792.2229.7.camel@ul30vt.home>
	 <CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 10:01 +0800, Jason Gao wrote:
> On Fri, Dec 14, 2012 at 12:23 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > Device 03:00.0 is your raid controller:
> >
> > 03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
> >
> > For some reason it's trying to read from ffe65000, ffe8a000, ffe89000,
> > ffe86000, ffe87000, ffe84000.  Those are in reserved memory regions, so
> > it's not reading an OS allocated buffer, which probably means it's some
> > kind of side-band communication with a management controller.  I'd guess
> > it's a BIOS bug and there should be an RMRR covering those accesses.
> > Thanks,
> 
> First of all ,I want to known whether I can ignore these errors on the
> production server,and do these error may affect the system?

You'll have to make that call, the device is being blocked from reading
a memory address, we don't know what it's reading or why.

> By the way,when I removed the "intel_iommu=on" from /etc/grub.conf,no
> DMAR related errors occur

Of course.  One option you have is to use the iommu in passthrough mode
which allows host used devices unrestricted, identity mapped access to
the system while still offering PCI device assignment.  I wouldn't try
assigning device 3:00.0 though.  Add iommu=pt to enable this.

> It's a strange thing,other three Dell R710 servers with the same bios
> version v. 6.3.0, same kernel 2.6.32-279.14.1 on RHEL6u3(Centos 6u3)
> ,but these errors don't appear on these tree servers

Is the MegaRAID firmware and system management firmware the same as
well?  Thanks,

Alex

