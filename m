Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1BEXVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 18:21:31 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:46100 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753870Ab1BEXV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 18:21:29 -0500
X-Greylist: delayed 1841 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 18:21:29 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
	b=jCAlwFStABqfh0JBEikZiZnhy3rayxgoCZSU915isotrU823D2e0IZxja2evf7FXlTG9EdozcpSSwzrVPGGZ+8tGCZhctLp8pE62DBG8kZapqJceXQZV7Et0hyha33fS;
Subject: Re: [BUG] usb problems in .38-rc3+
From: Przemo Firszt <przemo@firszt.eu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1102051515330.4210-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1102051515330.4210-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 22:50:35 +0000
Message-ID: <1296946235.2866.10.camel@pldmachine>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 PLD Linux 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2011-02-05, sob o godzinie 15:16 -0500, Alan Stern pisze:
> On Sat, 5 Feb 2011, Ed Tomlinson wrote:
> 
> > Hi,
> > 
> > My bluetooth usb dongle has stopped working in .38-rc3+
> > 
> > Bus 002 Device 008: ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
> > 
> > and in dmesg
> > 
> > [108495.369056] usb 5-1: new full speed USB device using ohci_hcd and address 3
> > [108495.573077] usb 5-1: New USB device found, idVendor=0a12, idProduct=0001
> > [108495.580099] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > [108652.971977] usb 5-1: USB disconnect, address 3
> > [108652.972718] btusb_bulk_complete: hci0 urb ffff8800684e99c0 failed to resubmit (19)
> > [108652.973725] btusb_bulk_complete: hci0 urb ffff8800684e9c00 failed to resubmit (19)
> > [108652.974707] btusb_intr_complete: hci0 urb ffff8800684e9840 failed to resubmit (19)
> > [108653.001690] btusb_send_frame: hci0 urb ffff8800bb42a240 submission failed
> > [108657.007541] usb 2-4.7: new full speed USB device using ehci_hcd and address 8
> > [108657.147736] usb 2-4.7: New USB device found, idVendor=0a12, idProduct=0001
> > [108657.154954] usb 2-4.7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > 
> > Its been working for years here.
> > 
> > Any ideas on what to try or additional info to gather?
> 
> Does it still work with earlier kernels or on other computers?
[przemo@pldmachine ~]$ lsusb
[..]
Bus 003 Device 002: ID 03f0:011d Hewlett-Packard Integrated Bluetooth
Module
[przemo@pldmachine ~]$ uname -a
Linux pldmachine 2.6.38-rc3-00201-g44f2c5c #7 Sat Feb 5 21:42:38 GMT
2011 i686 Intel(R)_Pentium(R)_M_processor_1.86GHz PLD Linux

Works fine for me - tested with a wacom tablet. I have built-in
bluetooth and the dongle. There is something in dmesg:

usb 3-2: new full speed USB device using uhci_hcd and address 2
usb 3-2: New USB device found, idVendor=03f0, idProduct=011d
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: HP integrated Bluetooth module
usb 3-2: Manufacturer: Broadcom
intel8x0_measure_ac97_clock: measured 52706 usecs (2540 samples)
intel8x0: clocking to 48000
Adding 3068376k swap on /dev/sda1.  Priority:-1 extents:1
across:3068376k 
EXT4-fs (sda2): warning: maximal mount count reached, running e2fsck is
recommended
EXT4-fs (sda2): re-mounted. Opts: (null)
input: PS/2 Generic Mouse
as /devices/platform/i8042/serio4/serio5/input/input5
auditd (1883): /proc/1883/oom_adj is deprecated, please
use /proc/1883/oom_score_adj instead.
Bluetooth: L2CAP ver 2.15
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
------------[ cut here ]------------
WARNING: at kernel/printk.c:430 do_syslog+0x347/0x36d()
Hardware name: HP Compaq nc4200 (PV983AW#ABU)  
Attempt to access syslog with CAP_SYS_ADMIN but no CAP_SYSLOG
(deprecated and denied).
Modules linked in: rfcomm bnep l2cap btusb bluetooth pcmcia ipw2200
snd_intel8x0 snd_ac97_codec libipw cfg80211 ac97_bus snd_pcm rfkill
yenta_socket tpm_infineon sdhci_pci sdhci snd_timer pcmcia_rsrc uhci_hcd
ehci_hcd mmc_core snd lib80211 tg3 pcmcia_core sg psmouse tpm container
ac usbcore fan battery processor thermal evdev soundcore snd_page_alloc
tpm_bios ata_piix libata sd_mod crc_t10dif scsi_mod ext4 mbcache jbd2
crc16 jbd [last unloaded: scsi_wait_scan]
Pid: 1993, comm: syslog-ng Not tainted 2.6.38-rc3-00201-g44f2c5c #7
Call Trace:
 [<c10195f2>] ? warn_slowpath_common+0x6a/0x7d
 [<c1019ce2>] ? do_syslog+0x347/0x36d
 [<c101966b>] ? warn_slowpath_fmt+0x28/0x2c
 [<c1019ce2>] ? do_syslog+0x347/0x36d
 [<c10c82c1>] ? smack_inode_permission+0x3b/0x42
 [<c10b4798>] ? kmsg_release+0x0/0x11
 [<c10b47b9>] ? kmsg_open+0x10/0x12
 [<c10ae32f>] ? proc_reg_open+0x63/0xc4
 [<c10c6674>] ? security_dentry_open+0x47/0x4d
 [<c10ae2cc>] ? proc_reg_open+0x0/0xc4
 [<c107c316>] ? __dentry_open+0xfb/0x1eb
 [<c107cfc8>] ? nameidata_to_filp+0x32/0x3d
 [<c10862f9>] ? finish_open+0x7f/0x11f
 [<c10867c3>] ? do_filp_open+0x16e/0x563
 [<c124a464>] ? do_page_fault+0x378/0x392
 [<c124a451>] ? do_page_fault+0x365/0x392
 [<c108db95>] ? alloc_fd+0x41/0xa5
[<c107d014>] ? do_sys_open+0x41/0xbe
 [<c107d0af>] ? sys_open+0x1e/0x23
 [<c100264c>] ? sysenter_do_call+0x12/0x22
---[ end trace 889c8d9ad011dab5 ]---
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
ADDRCONF(NETDEV_UP): lan: link is not ready
wireless: no IPv6 routers present
ata1.00: configured for UDMA/100
ata1: EH complete
blueman-applet[2631]: segfault at b7896048 ip b778e077 sp bfe08324 error
7 in libpython2.7.so.1.0[b7725000+138000]
lib80211_crypt: registered algorithm 'CCMP'
Intel AES-NI instructions are not detected.
lib80211_crypt: registered algorithm 'TKIP'
EXT4-fs (sda2): re-mounted. Opts: commit=0
hci_cmd_task: hci0 command tx timeout
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
input: WACOM Pen Tablet
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:1/input6
wacom 0005:056A:0081.0001: input,hidraw0: BLUETOOTH HID v1.00 Mouse
[WACOM Pen Tablet] on 00:1F:81:00:08:30
hci_cmd_task: hci0 command tx timeout
hci_cmd_task: hci0 command tx timeout
hci_cmd_task: hci0 command tx timeout


-- 
Przemo Firszt

