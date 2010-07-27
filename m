Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab0G0Tum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:50:42 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:33863 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0G0Tul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:50:41 -0400
Date: Tue, 27 Jul 2010 21:50:34 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_port_flush_task, BUG: unable to handle kernel paging
 request
Message-ID: <20100727195034.GP31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
References: <20100725154816.GF31966@localhost>
 <4C4E9C3B.9070402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4E9C3B.9070402@kernel.org>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Tejun,

  Thank you for your time.

# Which kernel version is this?  What was the configuration and what
# were the system doing?  Can you please post lspci -nn output and boot
# log?
Linux host 2.6.33.1 #3 PREEMPT Wed Mar 31 13:22:30 CEST 2010 i686 GNU/Linux

config: Internal sata disk.

action: iirc it was during a suspend/resume cycle or just during normal operation.

the boot log of this particular boot/uptime when it happened isn't available any more.
fastboot is enabled, hdparm, laptop-mode and smartd are enabled (std debian config)


    Hope this helps,

                Nils


lspci -nn:
00:00.0 Host bridge [0600]: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub [8086:2a00] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller [8086:2a02] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller [8086:2a03] (rev 03)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 [8086:2834] (rev 03)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 [8086:2835] (rev 03)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 [8086:283a] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audio Controller [8086:284b] (rev 03)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 [8086:283f] (rev 03)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 [8086:2841] (rev 03)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 [8086:2843] (rev 03)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 [8086:2830] (rev 03)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI C
ontroller #2 [8086:2831] (rev 03)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 [8086:2832] (rev 03)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 [8086:2836] (rev 03)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev f3)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller [8086:2815] (rev 03)
00:1f.1 IDE interface [0101]: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller [8086:2850] (rev 03)
00:1f.2 IDE interface [0101]: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller [8086:2828] (rev 03)
00:1f.3 SMBus [0c05]: Intel Corporation 82801H (ICH8 Family) SMBus Controller [8086:283e] (rev 03)
02:00.0 Ethernet controller [0200]: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet PCI Express [14e4:1693] (rev 02)
04:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5001 Wireless Network Adapter [168c:001c] (rev 01)
0f:06.0 CardBus bridge [0607]: Texas Instruments PCIxx12 Cardbus Controller [104c:8039]
0f:06.1 FireWire (IEEE 1394) [0c00]: Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller [104c:803a]
0f:06.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
0f:06.3 SD Host controller [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller [104c:803c]

/proc/config.gz:

CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_MISC_DEVICES=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y

CONFIG_HAVE_IDE=y

CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_ATA_PIIX=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_MULTIPATH=y


On Tue 2010-07-27 @ 10-43-39AM +0200, Tejun Heo wrote: 
# (cc'ing linux-ide)
# Hello,
# 
# On 07/25/2010 05:48 PM, Nils Radtke wrote:
# >   Hi,
# > 
# > Ideas, anybody?
# > 
# > BUG: unable to handle kernel paging request at 10ec83c6
# > IP: [<c13b8880>] ata_port_flush_task+0x0/0x50
# > *pde = 00000000 
# > Oops: 0002 [#1] PREEMPT 
# > last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/carrier
# > Modules linked in: snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo option usbserial usb_storage video1394 raw1394 dv1394 firewire_ohci firewire_core ohci1394 ieee1394 tg3 libphy
# > 
# > Pid: 1298, comm: scsi_eh_0 Not tainted 2.6.33 #6 Columbia                       /Extensa 5220                   
# > EIP: 0060:[<c13b8880>] EFLAGS: 00010292 CPU: 0
# > EIP is at ata_port_flush_task+0x0/0x50
# > EAX: f6878000 EBX: 00000246 ECX: 00000003 EDX: c13c7ab0
# > ESI: f6813800 EDI: f6813844 EBP: 00000000 ESP: f6877f48
# >  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
# > Process scsi_eh_0 (pid: 1298, ti=f6876000 task=f70603f0 task.ti=f6876000)
# > Stack:
# >  c13c7aca c1852b50 f6acbc80 f6acbc80 c102fb3e f6acbc80 f70603f0 c184a5a0
# > <0> f6813800 c184a400 f6878000 f70603f0 00000246 f6813800 f6813844 00000000
# > <0> c138a5af 00000000 c13897b0 c102bd97 f70603f0 f70603f0 f6813834 f6813844
# > Call Trace:
# >  [<c13c7aca>] ? ata_scsi_error+0x1a/0x870
# >  [<c102fb3e>] ? finish_task_switch+0x2e/0xa0
# >  [<c138a5af>] ? scsi_error_handler+0x9f/0x3a0
# >  [<c13897b0>] ? eh_lock_door_done+0x0/0x10
# >  [<c102bd97>] ? pick_next_task_fair+0x97/0xe0
# >  [<c1671f0a>] ? schedule+0x28a/0x3b0
# >  [<c138a510>] ? scsi_error_handler+0x0/0x3a0
# >  [<c104f3f4>] ? kthread+0x74/0x80
# >  [<c104f380>] ? kthread+0x0/0x80
# >  [<c1003236>] ? kernel_thread_helper+0x6/0x10
# > Code: 18 00 00 b8 a5 f7 7b c1 e8 2e b8 c7 ff eb 81 8d b6 00 00 00 00 8d bf 00 00 00 00 83 c0 5c e8 48 d3 fb ff e9 43 ff ff ff 8d 76 00 <ff> 89 c3 83 ec 10 8d 80 75 1e 00 00 e8 bf 3d c9 ff f6 83 c4 1e 
# > EIP: [<c13b8880>] ata_port_flush_task+0x0/0x50 SS:ESP 0068:f6877f48
# > CR2: 0000000010ec83c6
# > ---[ end trace 2f757ea4d01bedcf ]---
# 
# 
# -- 
# tejun

