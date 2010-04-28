Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab0D1OIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:08:36 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58816 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab0D1OIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=HmG0CEmzWCtG2VsHj+bbfXiw9k6sfcCzHH+4NqCdAf7GWdAReSAj2fg/D5IOsQ2EtP
         s2CBnzIlvT/nY6C74dqMHuWP4ePS3IQKAkGp2xD6g3W42ObeX8J1P/vpeFp8z50M0x+S
         p8U9Cv5lx9Gp8tR4cJYOPypMT+qMQKLo/+8p4=
Message-ID: <4BD8415C.9060409@gmail.com>
Date: Thu, 29 Apr 2010 00:08:28 +1000
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts JFFS2
 rootfs, Stops at init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I've been working for a while now getting the x86 U-Boot port up to speed
to boot a linux kernel

I now have a root fs (build from Linux-From-Scratch and trimmed to <15M
using qemu) but all attempts to get any serial console output past
launching of init have failed.

I have taken the root fs which successfully boots using qemu and created a
jffs2 image and flashed it onto one of the on-board flash chips. U-Boot can
successfully 'ls' the root fs

My bootags are:

  root=/dev/mtdblock1 rw rootfstype=jffs2 console=ttyS0,115200

as Linux can mount the root partition:
[    1.447819] Serial: 8250/16550 driver, 6 ports, IRQ sharing disabled
[    1.450027] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.452421] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.505824] brd: module loaded
[    1.507350] Uniform Multi-Platform E-IDE driver
[    1.509245] ide-gd driver 1.18
[    1.512852] Serck eNET flash device: 0x1000000 at 0x10000000
[    1.523853] eNET_Flash_0: Found 1 x16 devices at 0x0 in 16-bit bank
[    1.524828]  Intel/Sharp Extended Query Table at 0x0031
[    1.526492]  Intel/Sharp Extended Query Table at 0x0031
[    1.527492] Using buffer write method
[    1.528242] cfi_cmdset_0001: Erase suspend on write enabled
[    1.529242] Serck eNET flash device: 0x1000000 at 0x11000000
[    1.539872] eNET_Flash_1: Found 1 x16 devices at 0x0 in 16-bit bank
[    1.540951]  Intel/Sharp Extended Query Table at 0x0031
[    1.543632]  Intel/Sharp Extended Query Table at 0x0031
[    1.544426] Using buffer write method
[    1.545495] cfi_cmdset_0001: Erase suspend on write enabled
[    1.547452] Serck eNET flash device: 0x80000 at 0x38000000
[    1.549664] Found: AMD AM29LV040B
[    1.550136] eNET_Boot_Flash: Found 1 x8 devices at 0x0 in 8-bit bank
[    1.551136] number of JEDEC chips: 1
[    1.551975] Adding Device 0
[    1.556819] Partitioning Device 1
[    1.558150] Creating 1 MTD partitions on "eNET_Flash_1":
[    1.559150] 0x000000000000-0x000001000000 : "rootfs"
[    1.563816] Adding Device 2
[    1.568821] 8139too Fast Ethernet driver 0.9.28
[    1.573803] eth0: RealTek RTL8139 at 0xc8896000, 00:40:f4:6e:67:ac, IRQ 10
[    1.578796] eth1: RealTek RTL8139 at 0xc889a100, 00:40:f4:6e:67:ac, IRQ 9
[    1.582822] TCP cubic registered
[    1.584516] Using IPI Shortcut mode
[    1.901864] VFS: Mounted root (jffs2 filesystem) on device 31:1.
[    1.902926] Freeing unused kernel memory: 204k freed
[    1.909817] Write protecting the kernel text: 1924k
[    1.911896] Write protecting the kernel read-only data: 596k
[    1.915842] kernel_execve(/sbin/init)

(I've added a printk in kernel_execve() which gives me the last line)

I  initially had hot-plug support compiled into the kernel and was getting
a lot of kernel_execve(/sbin/hotplug) messages as well (plus a udev:
starting version 151 message which appear 100+ seconds and the above
messages), but I have since removed that and used mknod to create
/dev/ttyS0 directly

I have also tried the following test script:

#!/bin/bash
stty -F /dev/ttyS0 115200
cat hello > /dev/ttyS0

but still no luck

Does anyone have any advise on how I can debug this problem?

Regards,

Graeme
