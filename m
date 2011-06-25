Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1FYDQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 23:16:20 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:37104 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab1FYDQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 23:16:18 -0400
Date: Fri, 24 Jun 2011 23:16:16 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: Can't get sym53c8xx to work in kvm (qemu)
Message-ID: <20110625031616.GA12699@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would prefer to be CC'd on reply.

I am trying to use the LSI Logic / Symbios Logic 53c895a in the guest.  When
the module loads, all I see in dmesg is:
[    1.432545] sym53c8xx 0000:00:14.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
[    1.433414] sym53c8xx 0000:00:14.0: PCI INT A disabled

I have tried 2.6.3[479] vanilla kernels.  I have tried both 32-bit and
64-bit compiles.

If I boot ubuntu live 10.10 desktop (32-bit and 64-bit), I am able to see
the scsi disk.  I may need to point out that the kvm process was not
restarted when I boot to my kernel or the ubuntu live cd.

I am using debian with qemu-kvm 0.14.1+dfsg-1 and libvirt0 0.9.2-4.  I
created the VM with libvirt.  According to ps, the command is:
/usr/bin/kvm -S -M pc-0.14 -enable-kvm -m 1024
-smp 2,sockets=2,cores=1,threads=1 -name roshi
-uuid b34fc4d1-994e-422d-e552-d6f2297be392 -nodefconfig -nodefaults
-chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/roshi.monitor,server,nowait
-mon chardev=charmonitor,id=monitor,mode=readline -rtc base=utc -boot cn
-device lsi,id=scsi0,bus=pci.0,addr=0x14
-drive file=/dev/kamelvm/roshi,if=none,id=drive-virtio0-0-0,boot=on,format=raw
-device virtio-blk-pci,drive=drive-virtio0-0-0,id=virtio0-0-0
-drive file=/dev/kamelvm/roshi-tftpboot,if=none,id=drive-scsi0-0-0,format=raw
-device scsi-disk,bus=scsi0.0,scsi-id=0,drive=drive-scsi0-0-0,id=scsi0-0-0
-drive file=/tmp/ubuntu-10.10-desktop-i386.iso,if=none,media=cdrom,id=drive-ide1-0,readonly=on,format=raw
-device ide-drive,bus=ide.1,unit=0,drive=drive-ide0-1-0,id=ide0-1-0
-netdev tap,fd=20,id=hostnet0
-device e1000,netdev=hostnet0,id=net0,mac=52:54:00:9e:f7:d7,bus=pci.0,addr=0x5
-chardev pty,id=charserial0 -device isa-serial,chardev=charserial0,id=serial0
-usb -vnc 127.0.0.1:0 -vga cirrus
-device virtio-balloon-pci,id=balloon0,bus=pci.0,addr=0x6

I also tried it from the command line and removed chardev and mon and added
sdl and mon vc.  I had the same result.

NOTE: The virtio disk works.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
