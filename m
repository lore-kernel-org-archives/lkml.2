Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab2LJKmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:42:24 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48682 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2LJKmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:42:22 -0500
MIME-Version: 1.0
Date: Mon, 10 Dec 2012 11:42:22 +0100
Message-ID: <CADhePA2UTjvTmJOVnW_gNXmQ_T=Rk28HAf2pHqKj4akyp7+V9A@mail.gmail.com>
Subject: [3.7-rc8 regression] Buffer I/O error on device sda during boot
 (attempt to access beyond end of device)
From: M Z <magez.magez@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

booting vanilla  3.7-rc8 kernel on Acer Aspire 1810TZ yields these
errors (I was using 3.6.9-1 and 3.5.5-1 from Debian experimental
before without these errors)

 [    9.265058] attempt to access beyond end of device
 [    9.265063] sda1: rw=0, want=968382504, limit=968382503
 [    9.265066] Buffer I/O error on device sda1, logical block 121047812
 [    9.265069] attempt to access beyond end of device
 [    9.265071] sda1: rw=0, want=968382504, limit=968382503
 [    9.265073] Buffer I/O error on device sda1, logical block 121047812
 [    9.265383] attempt to access beyond end of device
 [    9.265387] sda1: rw=0, want=968382504, limit=968382503
 [    9.265389] Buffer I/O error on device sda1, logical block 121047812
...
 [    9.265058] attempt to access beyond end of device
 [    9.265063] sda1: rw=0, want=968382504, limit=968382503
 [    9.265066] Buffer I/O error on device sda1, logical block 121047812
 [    9.265069] attempt to access beyond end of device
 [    9.265071] sda1: rw=0, want=968382504, limit=968382503
 [    9.265073] Buffer I/O error on device sda1, logical block 121047812
 [    9.265383] attempt to access beyond end of device
 [    9.265387] sda1: rw=0, want=968382504, limit=968382503
 [    9.265389] Buffer I/O error on device sda1, logical block 121047812


Any idea before I hit the bisect route? (should I worry about these errors? :) )


Thanks


Matej Zary

-------
fdisk -l

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000486a3

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048   968384550   484191251+  83  Linux
/dev/sda2       968384551   976773167     4194308+  82  Linux swap / Solaris


lspci
00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
00:1a.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 03)
00:1a.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 4 (rev 03)
00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 03)
00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 03)
00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 03)
00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM
(ICH9M/ICH9M-E) 4 port SATA Controller [AHCI mode] (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
01:00.0 Ethernet controller: Atheros Communications Inc. AR8131
Gigabit Ethernet (rev c0)
02:00.0 Network controller: Intel Corporation Centrino Wireless-N 1000
