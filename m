Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1CIT16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:27:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1CIT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:27:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jgx3eNYqk2XbnbO52YQ8kT2+Oi36lUqZGa/ADQB8QkbnIIKxju5vCoz2JmnY8bd4kR
         bs5J1bLIHmLaDYJgfgpuxnbG202EjaAfNH4Dzq/2dgGwmQTK3ZC/nK3EbNR4pFJeeylI
         trLOIx575Gor+xFrp0e76gYT6Sq7+OuGtm5Bw=
Date: Wed, 9 Mar 2011 20:26:42 +0100
From: Johan Hovold <jhovold@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD-raid broken in 2.6.37.3?
Message-ID: <20110309192642.GA4098@localhost>
References: <20110309090622.GA3570@localhost>
 <20110309210251.744ef954@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20110309210251.744ef954@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 09, 2011 at 09:02:51PM +1100, NeilBrown wrote:
> On Wed, 9 Mar 2011 10:06:22 +0100 Johan Hovold <jhovold@gmail.com> wrote:
> 
> > Hi Greg and Neil,
> > 
> > I updated from 2.6.37.2 to 2.6.37.3 yesterday only to find that my
> > raid-0 partitions are no longer recognised. The raid-1 ones still are,
> > though. They did not show up after a reboot. (It has happened once
> > fairly recently that these exact partitions were not recognised but a
> > reboot fixed it -- blamed my disks.)
> > 
> > Today I mistakenly booted into 2.6.37.3 again -- still missing. No
> > problems with 2.6.37.2.
> > 
> > Browsing the changelog I found f663ed60892c3e1d4490b079a45d9e546271c40c
> > (md: Fix - again - partition detection when array becomes active) and
> > other md-related changes so I figure one of these could perhaps be to
> > blame?
> > 
> > As it is my personal/production machine I feel uncomfortable bisecting
> > this at this point, but maybe Neil has an idea of what might be going
> > on?
> 
> Hi Johan,
> 
>  could you please be a bit more specific about the problem that you
> experienced.
> What, exactly, was "no longer recognised"?
> 
> Was it that the array (e.g. /dev/md1) didn't appear, or was it that the
> array did appear, but that it has a partition table, and the partitions
> (e.g. /dev/md1p1, /dev/md1p2) did not appear?

It's the whole array that is missing. The raid-1 arrays appear but the
raid-0 does not.

> If you still have the boot-log from when you booted 2.6.37.3 (or can
> recreated) and can get a similar log for 2.6.37.2, then it might be useful to
> compare them.

Attaching two boot logs for 2.6.37.3 with /dev/md6 missing, and one for
2.6.37.2.

Note that md1, md2, and md3 have v0.90 superblocks, whereas md5 and md6 have
v1.20 ones and are assembled later.

When /dev/md6 is successfully assembled, through the gentoo init scripts
calling "mdadm -As", the log contains:

	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda6>
	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sda5>
	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb5>
	messages.2:Mar  8 20:44:19 xi kernel: md: bind<sdb6>

and when it fails, either the sda6 or sdb6 bind is missing:

	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sda6>
	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sdb5>
	messages.3-1:Mar  8 20:04:39 xi kernel: md: bind<sda5>

	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sdb6>
	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sdb5>
	messages.3-2:Mar  8 20:41:09 xi kernel: md: bind<sda5>

I mentioned that something similar had happened before, but that a
reboot fixed it. Tonight I cannot seem to be able to reproduce the
issue, so it's could very well be that the problem lies elsewhere and
that only slightly changed timings or such made it appear three times in
a row in the three first 2.6.37.3 boots (with 2.6.37.2 working in
between)...

Thanks,
Johan

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="messages.3-1"

Mar  8 20:04:38 xi syslogd 1.4.1: restart.
Mar  8 20:04:39 xi kernel: klogd 1.4.1, log source = /proc/kmsg started.
Mar  8 20:04:39 xi kernel: Inspecting /boot/System.map-2.6.37.3+

[...]

Mar  8 20:04:39 xi kernel: scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:04:39 xi kernel: sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:04:39 xi kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar  8 20:04:39 xi kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:04:39 xi kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  8 20:04:39 xi kernel: scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:04:39 xi kernel: sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:04:39 xi kernel: sd 1:0:0:0: [sdb] Write Protect is off
Mar  8 20:04:39 xi kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:04:39 xi kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Mar  8 20:04:39 xi kernel: ata5.00: configured for UDMA/133
Mar  8 20:04:39 xi kernel: scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
Mar  8 20:04:39 xi kernel: sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Mar  8 20:04:39 xi kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
Mar  8 20:04:39 xi kernel: sd 4:0:0:0: [sdc] Write Protect is off
Mar  8 20:04:39 xi kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:04:39 xi kernel:  sdc: sdc1
Mar  8 20:04:39 xi kernel: sd 4:0:0:0: [sdc] Attached SCSI disk
Mar  8 20:04:39 xi kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
Mar  8 20:04:39 xi kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Mar  8 20:04:39 xi kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  8 20:04:39 xi kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Mar  8 20:04:39 xi kernel: md: Waiting for all devices to be available before autodetect
Mar  8 20:04:39 xi kernel: md: If you don't use raid, use raid=noautodetect
Mar  8 20:04:39 xi kernel: md: Autodetecting RAID arrays.
Mar  8 20:04:39 xi kernel: usb 4-2: new low speed USB device using uhci_hcd and address 2
Mar  8 20:04:39 xi kernel: md: sdb5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:04:39 xi kernel: md: sdb6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:04:39 xi kernel: md: sda5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:04:39 xi kernel: md: sda6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:04:39 xi kernel: md: Scanned 8 and added 4 devices.
Mar  8 20:04:39 xi kernel: md: autorun ...
Mar  8 20:04:39 xi kernel: md: considering sda3 ...
Mar  8 20:04:39 xi kernel: md:  adding sda3 ...
Mar  8 20:04:39 xi kernel: md: sda1 has different UUID to sda3
Mar  8 20:04:39 xi kernel: md:  adding sdb3 ...
Mar  8 20:04:39 xi kernel: md: sdb1 has different UUID to sda3
Mar  8 20:04:39 xi kernel: md: created md3
Mar  8 20:04:39 xi kernel: md: bind<sdb3>
Mar  8 20:04:39 xi kernel: md: bind<sda3>
Mar  8 20:04:39 xi kernel: md: running: <sda3><sdb3>
Mar  8 20:04:39 xi kernel: bio: create slab <bio-1> at 1
Mar  8 20:04:39 xi kernel: md/raid1:md3: active with 2 out of 2 mirrors
Mar  8 20:04:39 xi kernel: md3: detected capacity change from 0 to 518062080
Mar  8 20:04:39 xi kernel: md: considering sda1 ...
Mar  8 20:04:39 xi kernel: md:  adding sda1 ...
Mar  8 20:04:39 xi kernel: md:  adding sdb1 ...
Mar  8 20:04:39 xi kernel: md: created md1
Mar  8 20:04:39 xi kernel: md: bind<sdb1>
Mar  8 20:04:39 xi kernel: md: bind<sda1>
Mar  8 20:04:39 xi kernel: md: running: <sda1><sdb1>
Mar  8 20:04:39 xi kernel: md/raid1:md1: active with 2 out of 2 mirrors
Mar  8 20:04:39 xi kernel: md1: detected capacity change from 0 to 73924608
Mar  8 20:04:39 xi kernel: md: ... autorun DONE.
Mar  8 20:04:39 xi kernel:  md3: unknown partition table
Mar  8 20:04:39 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:04:39 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:04:39 xi kernel: EXT3-fs (md3): mounted filesystem with writeback data mode
Mar  8 20:04:39 xi kernel: VFS: Mounted root (ext3 filesystem) readonly on device 9:3.
Mar  8 20:04:39 xi kernel: Freeing unused kernel memory: 380k freed
Mar  8 20:04:39 xi kernel: Write protecting the kernel text: 4964k
Mar  8 20:04:39 xi kernel: Write protecting the kernel read-only data: 1332k
Mar  8 20:04:39 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input11
Mar  8 20:04:39 xi kernel: generic-usb 0003:046D:C30E.0001: input: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input0
Mar  8 20:04:39 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input12
Mar  8 20:04:39 xi kernel: generic-usb 0003:046D:C30E.0002: input: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input1
Mar  8 20:04:39 xi kernel: usb 5-1: new low speed USB device using uhci_hcd and address 2
Mar  8 20:04:39 xi kernel: input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input13
Mar  8 20:04:39 xi kernel: generic-usb 0003:046D:C01B.0003: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
Mar  8 20:04:39 xi kernel: usb 5-2: new low speed USB device using uhci_hcd and address 3
Mar  8 20:04:39 xi kernel: udev: starting version 151
Mar  8 20:04:39 xi kernel: udevd (2028): /proc/2028/oom_adj is deprecated, please use /proc/2028/oom_score_adj instead.
Mar  8 20:04:39 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input14
Mar  8 20:04:39 xi kernel: logitech 0003:046D:C101.0004: input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.0-2/input0
Mar  8 20:04:39 xi kernel:  md1: unknown partition table
Mar  8 20:04:39 xi kernel: md: bind<sda6>
Mar  8 20:04:39 xi kernel: md: bind<sdb5>
Mar  8 20:04:39 xi kernel: md: bind<sda5>
Mar  8 20:04:39 xi kernel: md/raid1:md5: active with 2 out of 2 mirrors
Mar  8 20:04:39 xi kernel: md5: detected capacity change from 0 to 51546675200
Mar  8 20:04:39 xi kernel:  md5: unknown partition table
Mar  8 20:04:39 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input15
Mar  8 20:04:39 xi kernel: logitech 0003:046D:C101.0005: input: USB HID v1.10 Device [Logitech USB Receiver] on usb-0000:00:1d.0-2/input1
Mar  8 20:04:39 xi kernel: EXT3-fs (md3): using internal journal
Mar  8 20:04:39 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:04:39 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:04:39 xi kernel: EXT3-fs (md1): using internal journal
Mar  8 20:04:39 xi kernel: EXT3-fs (md1): mounted filesystem with writeback data mode
Mar  8 20:04:39 xi kernel: EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:04:39 xi kernel: EXT4-fs (dm-11): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:04:39 xi kernel: EXT4-fs (dm-12): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:04:39 xi kernel: EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:04:39 xi kernel: EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:04:39 xi kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
Mar  8 20:04:39 xi kernel: Adding 2008120k swap on /dev/sda2.  Priority:1 extents:1 across:2008120k 
Mar  8 20:04:39 xi kernel: Adding 2008120k swap on /dev/sdb2.  Priority:1 extents:1 across:2008120k 

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="messages.3-2"

Mar  8 20:41:08 xi syslogd 1.4.1: restart.
Mar  8 20:41:09 xi kernel: klogd 1.4.1, log source = /proc/kmsg started.
Mar  8 20:41:09 xi kernel: Inspecting /boot/System.map-2.6.37.3+

[...]

Mar  8 20:41:09 xi kernel: scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:41:09 xi kernel: ata2.00: configured for UDMA/133
Mar  8 20:41:09 xi kernel: sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:41:09 xi kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar  8 20:41:09 xi kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  8 20:41:09 xi kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:41:09 xi kernel: scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:41:09 xi kernel: sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:41:09 xi kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Mar  8 20:41:09 xi kernel: scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
Mar  8 20:41:09 xi kernel: sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Mar  8 20:41:09 xi kernel: sd 4:0:0:0: [sdc] Write Protect is off
Mar  8 20:41:09 xi kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:41:09 xi kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
Mar  8 20:41:09 xi kernel: sd 1:0:0:0: [sdb] Write Protect is off
Mar  8 20:41:09 xi kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:41:09 xi kernel:  sdc: sdc1
Mar  8 20:41:09 xi kernel: sd 4:0:0:0: [sdc] Attached SCSI disk
Mar  8 20:41:09 xi kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  8 20:41:09 xi kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Mar  8 20:41:09 xi kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
Mar  8 20:41:09 xi kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Mar  8 20:41:09 xi kernel: md: Waiting for all devices to be available before autodetect
Mar  8 20:41:09 xi kernel: md: If you don't use raid, use raid=noautodetect
Mar  8 20:41:09 xi kernel: md: Autodetecting RAID arrays.
Mar  8 20:41:09 xi kernel: md: sda5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:41:09 xi kernel: usb 4-2: new low speed USB device using uhci_hcd and address 2
Mar  8 20:41:09 xi kernel: md: sda6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:41:09 xi kernel: md: sdb5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:41:09 xi kernel: md: sdb6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:41:09 xi kernel: md: Scanned 8 and added 4 devices.
Mar  8 20:41:09 xi kernel: md: autorun ...
Mar  8 20:41:09 xi kernel: md: considering sdb3 ...
Mar  8 20:41:09 xi kernel: md:  adding sdb3 ...
Mar  8 20:41:09 xi kernel: md: sdb1 has different UUID to sdb3
Mar  8 20:41:09 xi kernel: md:  adding sda3 ...
Mar  8 20:41:09 xi kernel: md: sda1 has different UUID to sdb3
Mar  8 20:41:09 xi kernel: md: created md3
Mar  8 20:41:09 xi kernel: md: bind<sda3>
Mar  8 20:41:09 xi kernel: md: bind<sdb3>
Mar  8 20:41:09 xi kernel: md: running: <sdb3><sda3>
Mar  8 20:41:09 xi kernel: bio: create slab <bio-1> at 1
Mar  8 20:41:09 xi kernel: md/raid1:md3: active with 2 out of 2 mirrors
Mar  8 20:41:09 xi kernel: md3: detected capacity change from 0 to 518062080
Mar  8 20:41:09 xi kernel: md: considering sdb1 ...
Mar  8 20:41:09 xi kernel: md:  adding sdb1 ...
Mar  8 20:41:09 xi kernel: md:  adding sda1 ...
Mar  8 20:41:09 xi kernel: md: created md1
Mar  8 20:41:09 xi kernel: md: bind<sda1>
Mar  8 20:41:09 xi kernel: md: bind<sdb1>
Mar  8 20:41:09 xi kernel: md: running: <sdb1><sda1>
Mar  8 20:41:09 xi kernel: md/raid1:md1: active with 2 out of 2 mirrors
Mar  8 20:41:09 xi kernel: md1: detected capacity change from 0 to 73924608
Mar  8 20:41:09 xi kernel: md: ... autorun DONE.
Mar  8 20:41:09 xi kernel:  md3: unknown partition table
Mar  8 20:41:09 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:41:09 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:41:09 xi kernel: EXT3-fs (md3): mounted filesystem with writeback data mode
Mar  8 20:41:09 xi kernel: VFS: Mounted root (ext3 filesystem) readonly on device 9:3.
Mar  8 20:41:09 xi kernel: Freeing unused kernel memory: 380k freed
Mar  8 20:41:09 xi kernel: Write protecting the kernel text: 4964k
Mar  8 20:41:09 xi kernel: Write protecting the kernel read-only data: 1332k
Mar  8 20:41:09 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input11
Mar  8 20:41:09 xi kernel: generic-usb 0003:046D:C30E.0001: input: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input0
Mar  8 20:41:09 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input12
Mar  8 20:41:09 xi kernel: generic-usb 0003:046D:C30E.0002: input: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input1
Mar  8 20:41:09 xi kernel: usb 5-1: new low speed USB device using uhci_hcd and address 2
Mar  8 20:41:09 xi kernel: input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input13
Mar  8 20:41:09 xi kernel: generic-usb 0003:046D:C01B.0003: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
Mar  8 20:41:09 xi kernel: usb 5-2: new low speed USB device using uhci_hcd and address 3
Mar  8 20:41:09 xi kernel: udev: starting version 151
Mar  8 20:41:09 xi kernel: udevd (2028): /proc/2028/oom_adj is deprecated, please use /proc/2028/oom_score_adj instead.
Mar  8 20:41:09 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input14
Mar  8 20:41:09 xi kernel: logitech 0003:046D:C101.0004: input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.0-2/input0
Mar  8 20:41:09 xi kernel:  md1: unknown partition table
Mar  8 20:41:09 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input15
Mar  8 20:41:09 xi kernel: logitech 0003:046D:C101.0005: input: USB HID v1.10 Device [Logitech USB Receiver] on usb-0000:00:1d.0-2/input1
Mar  8 20:41:09 xi kernel: md: bind<sdb6>
Mar  8 20:41:09 xi kernel: md: bind<sdb5>
Mar  8 20:41:09 xi kernel: md: bind<sda5>
Mar  8 20:41:09 xi kernel: md/raid1:md5: active with 2 out of 2 mirrors
Mar  8 20:41:09 xi kernel: md5: detected capacity change from 0 to 51546675200
Mar  8 20:41:09 xi kernel:  md5: unknown partition table
Mar  8 20:41:09 xi kernel: EXT3-fs (md3): using internal journal
Mar  8 20:41:09 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:41:09 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:41:09 xi kernel: EXT3-fs (md1): using internal journal
Mar  8 20:41:09 xi kernel: EXT3-fs (md1): mounted filesystem with writeback data mode
Mar  8 20:41:09 xi kernel: EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:41:09 xi kernel: EXT4-fs (dm-11): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:41:09 xi kernel: EXT4-fs (dm-12): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:41:09 xi kernel: EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:41:09 xi kernel: EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:41:09 xi kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
Mar  8 20:41:09 xi kernel: Adding 2008120k swap on /dev/sda2.  Priority:1 extents:1 across:2008120k 
Mar  8 20:41:09 xi kernel: Adding 2008120k swap on /dev/sdb2.  Priority:1 extents:1 across:2008120k 

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="messages.2"

Mar  8 20:44:18 xi syslogd 1.4.1: restart.
Mar  8 20:44:19 xi kernel: klogd 1.4.1, log source = /proc/kmsg started.
Mar  8 20:44:19 xi kernel: Inspecting /boot/System.map-2.6.37.2+'

[...]

Mar  8 20:44:19 xi kernel: scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:44:19 xi kernel: sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:44:19 xi kernel: sd 0:0:0:0: [sda] Write Protect is off
Mar  8 20:44:19 xi kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  8 20:44:19 xi kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:44:19 xi kernel: scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
Mar  8 20:44:19 xi kernel: sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Mar  8 20:44:19 xi kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Mar  8 20:44:19 xi kernel: scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD204UI  1AQ1 PQ: 0 ANSI: 5
Mar  8 20:44:19 xi kernel: sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Mar  8 20:44:19 xi kernel: sd 4:0:0:0: [sdc] Write Protect is off
Mar  8 20:44:19 xi kernel: sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:44:19 xi kernel: sd 4:0:0:0: Attached scsi generic sg2 type 0
Mar  8 20:44:19 xi kernel: sd 1:0:0:0: [sdb] Write Protect is off
Mar  8 20:44:19 xi kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 20:44:19 xi kernel:  sdc: sdc1
Mar  8 20:44:19 xi kernel: sd 4:0:0:0: [sdc] Attached SCSI disk
Mar  8 20:44:19 xi kernel:  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  8 20:44:19 xi kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Mar  8 20:44:19 xi kernel:  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
Mar  8 20:44:19 xi kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Mar  8 20:44:19 xi kernel: md: Waiting for all devices to be available before autodetect
Mar  8 20:44:19 xi kernel: md: If you don't use raid, use raid=noautodetect
Mar  8 20:44:19 xi kernel: md: Autodetecting RAID arrays.
Mar  8 20:44:19 xi kernel: usb 4-2: new low speed USB device using uhci_hcd and address 2
Mar  8 20:44:19 xi kernel: md: sda5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:44:19 xi kernel: md: sda6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:44:19 xi kernel: md: sdb5 does not have a valid v0.90 superblock, not importing!
Mar  8 20:44:19 xi kernel: md: sdb6 does not have a valid v0.90 superblock, not importing!
Mar  8 20:44:19 xi kernel: md: Scanned 8 and added 4 devices.
Mar  8 20:44:19 xi kernel: md: autorun ...
Mar  8 20:44:19 xi kernel: md: considering sdb3 ...
Mar  8 20:44:19 xi kernel: md:  adding sdb3 ...
Mar  8 20:44:19 xi kernel: md: sdb1 has different UUID to sdb3
Mar  8 20:44:19 xi kernel: md:  adding sda3 ...
Mar  8 20:44:19 xi kernel: md: sda1 has different UUID to sdb3
Mar  8 20:44:19 xi kernel: md: created md3
Mar  8 20:44:19 xi kernel: md: bind<sda3>
Mar  8 20:44:19 xi kernel: md: bind<sdb3>
Mar  8 20:44:19 xi kernel: md: running: <sdb3><sda3>
Mar  8 20:44:19 xi kernel: bio: create slab <bio-1> at 1
Mar  8 20:44:19 xi kernel: md/raid1:md3: active with 2 out of 2 mirrors
Mar  8 20:44:19 xi kernel: md3: detected capacity change from 0 to 518062080
Mar  8 20:44:19 xi kernel: md: considering sdb1 ...
Mar  8 20:44:19 xi kernel: md:  adding sdb1 ...
Mar  8 20:44:19 xi kernel: md:  adding sda1 ...
Mar  8 20:44:19 xi kernel: md: created md1
Mar  8 20:44:19 xi kernel: md: bind<sda1>
Mar  8 20:44:19 xi kernel: md: bind<sdb1>
Mar  8 20:44:19 xi kernel: md: running: <sdb1><sda1>
Mar  8 20:44:19 xi kernel: md/raid1:md1: active with 2 out of 2 mirrors
Mar  8 20:44:19 xi kernel: md1: detected capacity change from 0 to 73924608
Mar  8 20:44:19 xi kernel: md: ... autorun DONE.
Mar  8 20:44:19 xi kernel: md3: detected capacity change from 0 to 518062080
Mar  8 20:44:19 xi kernel:  md3: unknown partition table
Mar  8 20:44:19 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:44:19 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:44:19 xi kernel: EXT3-fs (md3): mounted filesystem with writeback data mode
Mar  8 20:44:19 xi kernel: VFS: Mounted root (ext3 filesystem) readonly on device 9:3.
Mar  8 20:44:19 xi kernel: Freeing unused kernel memory: 380k freed
Mar  8 20:44:19 xi kernel: Write protecting the kernel text: 4960k
Mar  8 20:44:19 xi kernel: Write protecting the kernel read-only data: 1336k
Mar  8 20:44:19 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.0/input/input11
Mar  8 20:44:19 xi kernel: generic-usb 0003:046D:C30E.0001: input: USB HID v1.10 Keyboard [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input0
Mar  8 20:44:19 xi kernel: input: Logitech HID compliant keyboard as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2:1.1/input/input12
Mar  8 20:44:19 xi kernel: generic-usb 0003:046D:C30E.0002: input: USB HID v1.10 Device [Logitech HID compliant keyboard] on usb-0000:00:1a.1-2/input1
Mar  8 20:44:19 xi kernel: usb 5-1: new low speed USB device using uhci_hcd and address 2
Mar  8 20:44:19 xi kernel: input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input13
Mar  8 20:44:19 xi kernel: generic-usb 0003:046D:C01B.0003: input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1/input0
Mar  8 20:44:19 xi kernel: usb 5-2: new low speed USB device using uhci_hcd and address 3
Mar  8 20:44:19 xi kernel: udev: starting version 151
Mar  8 20:44:19 xi kernel: udevd (2028): /proc/2028/oom_adj is deprecated, please use /proc/2028/oom_score_adj instead.
Mar  8 20:44:19 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/input/input14
Mar  8 20:44:19 xi kernel: logitech 0003:046D:C101.0004: input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.0-2/input0
Mar  8 20:44:19 xi kernel: md1: detected capacity change from 0 to 73924608
Mar  8 20:44:19 xi kernel:  md1: unknown partition table
Mar  8 20:44:19 xi kernel: md: bind<sda6>
Mar  8 20:44:19 xi kernel: md: bind<sda5>
Mar  8 20:44:19 xi kernel: md: bind<sdb5>
Mar  8 20:44:19 xi kernel: md/raid1:md5: active with 2 out of 2 mirrors
Mar  8 20:44:19 xi kernel: md5: detected capacity change from 0 to 51546675200
Mar  8 20:44:19 xi kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.1/input/input15
Mar  8 20:44:19 xi kernel: logitech 0003:046D:C101.0005: input: USB HID v1.10 Device [Logitech USB Receiver] on usb-0000:00:1d.0-2/input1
Mar  8 20:44:19 xi kernel:  md5: unknown partition table
Mar  8 20:44:19 xi kernel: md: bind<sdb6>
Mar  8 20:44:19 xi kernel: md/raid0:md6: looking at sdb6
Mar  8 20:44:19 xi kernel: md/raid0:md6:   comparing sdb6(870913024) with sdb6(870913024)
Mar  8 20:44:19 xi kernel: md/raid0:md6:   END
Mar  8 20:44:19 xi kernel: md/raid0:md6:   ==> UNIQUE
Mar  8 20:44:19 xi kernel: md/raid0:md6: 1 zones
Mar  8 20:44:19 xi kernel: md/raid0:md6: looking at sda6
Mar  8 20:44:19 xi kernel: md/raid0:md6:   comparing sda6(870913024) with sdb6(870913024)
Mar  8 20:44:19 xi kernel: md/raid0:md6:   EQUAL
Mar  8 20:44:19 xi kernel: md/raid0:md6: FINAL 1 zones
Mar  8 20:44:19 xi kernel: md/raid0:md6: done.
Mar  8 20:44:19 xi kernel: md/raid0:md6: md_size is 1741826048 sectors.
Mar  8 20:44:19 xi kernel: ******* md6 configuration *********
Mar  8 20:44:19 xi kernel: zone0=[sda6/sdb6/]
Mar  8 20:44:19 xi kernel:         zone offset=0kb device offset=0kb size=870913024kb
Mar  8 20:44:19 xi kernel: **********************************
Mar  8 20:44:19 xi kernel: 
Mar  8 20:44:19 xi kernel: md6: detected capacity change from 0 to 891814936576
Mar  8 20:44:19 xi kernel:  md6: unknown partition table
Mar  8 20:44:19 xi kernel: md1: detected capacity change from 0 to 73924608
Mar  8 20:44:19 xi kernel:  md1: unknown partition table
Mar  8 20:44:19 xi kernel: EXT3-fs (md3): using internal journal
Mar  8 20:44:19 xi kernel: EXT3-fs: barriers not enabled
Mar  8 20:44:19 xi kernel: kjournald starting.  Commit interval 5 seconds
Mar  8 20:44:19 xi kernel: EXT3-fs (md1): using internal journal
Mar  8 20:44:19 xi kernel: EXT3-fs (md1): mounted filesystem with writeback data mode
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-17): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-13): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-12): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-18): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-19): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-14): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-15): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-16): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: EXT4-fs (dm-11): mounted filesystem with ordered data mode. Opts: (null)
Mar  8 20:44:19 xi kernel: eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
Mar  8 20:44:19 xi kernel: Adding 2008120k swap on /dev/sda2.  Priority:1 extents:1 across:2008120k 
Mar  8 20:44:19 xi kernel: Adding 2008120k swap on /dev/sdb2.  Priority:1 extents:1 across:2008120k 

--9amGYk9869ThD9tj--
