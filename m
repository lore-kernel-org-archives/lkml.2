Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0D0THh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 15:07:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51890 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753766Ab0D0THf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 15:07:35 -0400
Date: Tue, 27 Apr 2010 15:07:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
cc: Robert Hancock <hancockrwd@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: INFO: umount blocked for more than 120 seconds
In-Reply-To: <20100427094614.GA3345@swordfish.minsk.epam.com>
Message-ID: <Pine.LNX.4.44L0.1004271457160.1850-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Sergey Senozhatsky wrote:

> Hello,
> 
> On (04/26/10 15:36), Alan Stern wrote:
> > Can you do this with CONFIG_USB_DEBUG enabled?  And acquire a usbmon 
> > trace at the same time (see Documentation/usb/usbmon.txt)?
> > 
> 
> mount as /media/fl/
> cp ./LLVM 2.0.mp4 /media/fl/    - (246M)
> umount /media/fl/
> 
> Please see usbmon.log attached.
> 
> kernel: [ 3228.543190] usb 2-2: new full speed USB device using uhci_hcd and address 4
> kernel: [ 3228.689814] usb 2-2: ep0 maxpacket = 16
> kernel: [ 3228.712027] usb 2-2: default language 0x0409
> kernel: [ 3228.731035] usb 2-2: udev 4, busnum 2, minor = 131
> kernel: [ 3228.731043] usb 2-2: New USB device found, idVendor=0b05, idProduct=422f
> kernel: [ 3228.731051] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> kernel: [ 3228.731058] usb 2-2: Product: Generic Mass Storage
> kernel: [ 3228.731064] usb 2-2: Manufacturer: ASUS
> kernel: [ 3228.731070] usb 2-2: SerialNumber: 7abf5000-2268-0801-3b00-072fa733ffff
> kernel: [ 3228.731640] usb 2-2: usb_probe_device
> kernel: [ 3228.731649] usb 2-2: configuration #1 chosen from 1 choice
> kernel: [ 3228.733180] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
> kernel: [ 3228.733661] usb-storage 2-2:1.0: usb_probe_interface
> kernel: [ 3228.733677] usb-storage 2-2:1.0: usb_probe_interface - got id
> kernel: [ 3228.734213] scsi4 : usb-storage 2-2:1.0
> kernel: [ 3229.738138] scsi scan: INQUIRY result too short (5), using 36
> kernel: [ 3229.738154] scsi 4:0:0:0: Direct-Access                                    PQ: 0 ANSI: 0
> kernel: [ 3229.746458] sd 4:0:0:0: Attached scsi generic sg2 type 0
> kernel: [ 3229.750731] sd 4:0:0:0: [sdb] 2012160 512-byte logical blocks: (1.03 GB/982 MiB)
> kernel: [ 3229.754031] sd 4:0:0:0: [sdb] Write Protect is off
> kernel: [ 3229.754036] sd 4:0:0:0: [sdb] Mode Sense: 00 06 00 00
> kernel: [ 3229.754039] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 3229.766121] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 3229.766134]  sdb: sdb1
> kernel: [ 3229.790123] sd 4:0:0:0: [sdb] Assuming drive cache: write through
> kernel: [ 3229.790135] sd 4:0:0:0: [sdb] Attached SCSI removable disk
> kernel: [ 3247.991259] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> kernel: [ 3840.643117] INFO: task umount:4902 blocked for more than 120 seconds.
> kernel: [ 3840.643125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> kernel: [ 3840.643133] umount        D 0000034e     0  4902   3943 0x00000000
> kernel: [ 3840.643146]  f640de38 00000046 3715ce5d 0000034e c1610cc0 c12c3938 c1610cc0 c1610cc0
> kernel: [ 3840.643170]  c1610cc0 c1610cc0 f51017d0 c1610cc0 00012bf1 00000000 3714a26c 0000034e
> kernel: [ 3840.643193]  f5101540 f640de40 f640de70 00000000 f640de78 f640de40 c10b7cf0 f640de5c
> kernel: [ 3840.643215] Call Trace:
> kernel: [ 3840.643234]  [<c12c3938>] ? _raw_spin_unlock_irqrestore+0x36/0x5b
> kernel: [ 3840.643249]  [<c10b7cf0>] bdi_sched_wait+0x8/0xc
> kernel: [ 3840.643259]  [<c12c2197>] __wait_on_bit+0x34/0x5b
> kernel: [ 3840.643268]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
> kernel: [ 3840.643279]  [<c12c2215>] out_of_line_wait_on_bit+0x57/0x5f
> kernel: [ 3840.643289]  [<c10b7ce8>] ? bdi_sched_wait+0x0/0xc
> kernel: [ 3840.643302]  [<c103fa75>] ? wake_bit_function+0x0/0x4d
> kernel: [ 3840.643313]  [<c10b84d4>] wait_on_bit.clone.0+0x17/0x23
> kernel: [ 3840.643323]  [<c10b8544>] sync_inodes_sb+0x64/0x10d
> kernel: [ 3840.643337]  [<c10d373f>] ? vfs_quota_sync+0x0/0x1da
> kernel: [ 3840.643348]  [<c10baef6>] __sync_filesystem+0x37/0x62
> kernel: [ 3840.643358]  [<c10bb062>] sync_filesystem+0x3c/0x3f
> kernel: [ 3840.643369]  [<c10a2def>] generic_shutdown_super+0x1c/0xca
> kernel: [ 3840.643380]  [<c10a2eba>] kill_block_super+0x1d/0x31
> kernel: [ 3840.643390]  [<c10a3833>] deactivate_super+0x48/0x5a
> kernel: [ 3840.643401]  [<c10b385c>] mntput_no_expire+0x5e/0x89
> kernel: [ 3840.643411]  [<c10b41cf>] sys_umount+0x277/0x29b
> kernel: [ 3840.643423]  [<c10b4200>] sys_oldumount+0xd/0xf
> kernel: [ 3840.643434]  [<c1002813>] sysenter_do_call+0x12/0x32
> kernel: [ 3840.643444] 1 lock held by umount/4902:
> kernel: [ 3840.643449]  #0:  (&type->s_umount_key#24){++++..}, at: [<c10a382e>] deactivate_super+0x43/0x5a

Robert was right.  Your usbmon log covers only the last 40 seconds of
data transfer and showed a little over 15 MB being sent, so it seems
likely that the entire 246 MB transfer would require more than 10
minutes.

You can test this easily enough by simply waiting for 12 minutes or so
before issuing the "umount" command.

Alan Stern

