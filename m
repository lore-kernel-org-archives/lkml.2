Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2LNHAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:00:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54140 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2LNHAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:00:51 -0500
MIME-Version: 1.0
In-Reply-To: <CANmqhJB4=Xuho0BrfhRO1hkL6yp=BxSxQoSAUgL=eNkZgyk8SQ@mail.gmail.com>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	<1355415792.2229.7.camel@ul30vt.home>
	<CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
	<1355460351.2229.20.camel@ul30vt.home>
	<CANmqhJB4=Xuho0BrfhRO1hkL6yp=BxSxQoSAUgL=eNkZgyk8SQ@mail.gmail.com>
Date: Fri, 14 Dec 2012 15:00:49 +0800
Message-ID: <CANmqhJC0hZBSRzcZ3ec6YJF8Z-utTh6xVziy5WMcd3aAP99LVg@mail.gmail.com>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:56 PM, Jason Gao <pkill.2012@gmail.com> wrote:
> On Fri, Dec 14, 2012 at 12:45 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
>> Is the MegaRAID firmware and system management firmware the same as
>> well?  Thanks.
>
> I'v updated  all the firmware using Dell's firmware-tools:
>
> # inventory_firmware
> Wait while we inventory system:
> System inventory:
>         BIOS = 6.3.0
>         SAS/SATA Backplane 0:0 Backplane Firmware = 1.07
>         PERC 6/i Integrated Controller 0 Firmware = 6.3.1-0003
>         Dell OS Drivers Pack, v.6.5.3, A00 = 6.5.3
>         Dell Lifecycle Controller = 1.5.5.27
>         NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth1) = 7.2.20
>         NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth0) = 7.2.20
>         ST3600057SS Firmware = es66
>         iDRAC6 = 1.92
>         NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth2) = 7.2.20
>         NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth3) = 7.2.20
>         Dell 32 Bit Diagnostics, v.5154A0, 5154.1 = 5154a0
>         System BIOS for PowerEdge R710 = 6.3.0
>
> Thanks

#lspci -vvvv -s 03:00.0|grep fail:
pcilib: sysfs_read_vpd: read failed: Connection timed out

#strace lspci -vvvv -s 03:00.0|grep fail:
....
open("/sys/bus/pci/devices/0000:03:00.0/vpd", O_RDONLY) = 4
pread(4, 0x7fff30670b3f, 1, 0)          = -1 ETIMEDOUT (Connection timed out)
write(2, "pcilib: ", 8pcilib: )                 = 8
write(2, "sysfs_read_vpd: read failed: Con"..., 49sysfs_read_vpd: read
failed: Connection timed out) = 49
write(2, "\n", 1
....
