Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab0DHNAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:00:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:53122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab0DHNAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lxzlBkfKoTk20ARCO/PHRKOEhoWep0scfT5x1xnkwjFUB4bmPCac2j755PKuTkx2Yf
         ihbhYN2nyiItCQWTPL8Egkx6AjwZrnzL1biAh9AMzAvw+pYogJYyO7xgB32vHleb1wLp
         Gjw1UoKxbnBrCSroeM9LeS1aVQ6/xeONu6a6k=
Date: Thu, 8 Apr 2010 13:06:07 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: dm-crypt@saout.de, pm-utils@lists.freedesktop.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.33.2 circular locking, hibernate, dm-crypt
Message-ID: <20100408110607.GB1788@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this might be a regression - have not seen this warning in 2.6.32 with identical
hardware. Btw the ageold usb-sound issue still appears present in 2.6.33.2, do not
think it is related but I mention it because it also frequently causes circular
locking warnings on my hardware.

Apr  7 16:23:45 localhost kernel: [    2.078022] usb 3-1: device not accepting address 2, error -71
Apr  7 16:23:45 localhost kernel: [    2.129053] hub 3-0:1.0: unable to enumerate USB device on port 1
Apr  7 16:23:45 localhost kernel: [    2.129175] usb 1-1: USB disconnect, address 2
Apr  7 16:23:45 localhost kernel: [    2.233049] usb 2-1: USB disconnect, address 2
Apr  7 16:23:45 localhost kernel: [    2.439027] usb 5-1: new high speed USB device using ehci_hcd and address 2
Apr  7 16:23:45 localhost kernel: [    2.694134] usb 5-1: New USB device found, idVendor=148f, idProduct=2573
Apr  7 16:23:45 localhost kernel: [    2.694221] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr  7 16:23:45 localhost kernel: [    2.694308] usb 5-1: Product: 54M.USB.......
Apr  7 16:23:45 localhost kernel: [    2.694392] usb 5-1: Manufacturer: Ralink
Apr  7 16:23:45 localhost kernel: [    2.796025] usb 5-3: new high speed USB device using ehci_hcd and address 3
Apr  7 16:23:45 localhost kernel: [    2.922285] usb 5-3: New USB device found, idVendor=19d2, idProduct=0063
Apr  7 16:23:45 localhost kernel: [    2.922373] usb 5-3: New USB device strings: Mfr=2, Product=1, SerialNumber=0
Apr  7 16:23:45 localhost kernel: [    2.922460] usb 5-3: Product: ZTE CDMA Technologies MSM
Apr  7 16:23:45 localhost kernel: [    2.922545] usb 5-3: Manufacturer: ZTE,Incorporated
Apr  7 16:23:45 localhost kernel: [    3.026021] usb 5-5: new high speed USB device using ehci_hcd and address 4
Apr  7 16:23:45 localhost kernel: [    3.171317] usb 5-5: New USB device found, idVendor=0ac8, idProduct=3420
Apr  7 16:23:45 localhost kernel: [    3.171404] usb 5-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Apr  7 16:23:45 localhost kernel: [    3.171489] usb 5-5: Product: Venus USB2.0 Camera
Apr  7 16:23:45 localhost kernel: [    3.171570] usb 5-5: Manufacturer: Vimicro Corp.
Apr  7 16:23:45 localhost kernel: [   23.173916] PM: Starting manual resume from disk
Apr  7 16:23:45 localhost kernel: [   23.174242] 
Apr  7 16:23:45 localhost kernel: [   23.174243] =======================================================
Apr  7 16:23:45 localhost kernel: [   23.174405] [ INFO: possible circular locking dependency detected ]
Apr  7 16:23:45 localhost kernel: [   23.174490] 2.6.33.2v0 #2
Apr  7 16:23:45 localhost kernel: [   23.174569] -------------------------------------------------------
Apr  7 16:23:45 localhost kernel: [   23.174653] init/1 is trying to acquire lock:
Apr  7 16:23:45 localhost kernel: [   23.174736]  (&bdev->bd_mutex){+.+.+.}, at: [<c04ec7e5>] __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.174945] 
Apr  7 16:23:45 localhost kernel: [   23.174946] but task is already holding lock:
Apr  7 16:23:45 localhost kernel: [   23.175009]  (pm_mutex/1){+.+...}, at: [<c04661f2>] software_resume+0x25/0x1f5
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] which lock already depends on the new lock.
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] the existing dependency chain (in reverse order) is:
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] -> #2 (pm_mutex/1){+.+...}:
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b60a>] __lock_acquire+0xa2d/0xbb7
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b828>] lock_acquire+0x94/0xb1
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0736d84>] __mutex_lock_common+0x35/0x2f3
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c07370e0>] mutex_lock_nested+0x30/0x38
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04661f2>] software_resume+0x25/0x1f5
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c046643a>] resume_store+0x78/0x88
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c05acb19>] kobj_attr_store+0x1a/0x22
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c050f306>] sysfs_write_file+0xb9/0xe4
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04cc821>] vfs_write+0x84/0xdf
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04cc915>] sys_write+0x3b/0x60
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0738295>] syscall_call+0x7/0xb
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] -> #1 (s_active){++++.+}:
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b60a>] __lock_acquire+0xa2d/0xbb7
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b828>] lock_acquire+0x94/0xb1
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c05102f8>] sysfs_addrm_finish+0x89/0xde
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c050eaf7>] sysfs_hash_and_remove+0x3d/0x4f
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c05106d5>] sysfs_remove_link+0x16/0x18
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04ebdbc>] bd_release_from_disk+0x6b/0xd4
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f806fb5b>] close_dev+0x1d/0x32 [dm_mod]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f806fb91>] dm_put_device+0x21/0x32 [dm_mod]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f80de00e>] crypt_dtr+0x79/0x84 [dm_crypt]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f806ff3d>] dm_table_destroy+0x56/0xc5 [dm_mod]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f8071f59>] dev_suspend+0x176/0x197 [dm_mod]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<f8072793>] dm_ctl_ioctl+0x182/0x1c3 [dm_mod]
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04d6cd5>] vfs_ioctl+0x22/0x87
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04d7279>] do_vfs_ioctl+0x49b/0x4d5
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04d72f3>] sys_ioctl+0x40/0x5a
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0738295>] syscall_call+0x7/0xb
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] -> #0 (&bdev->bd_mutex){+.+.+.}:
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b517>] __lock_acquire+0x93a/0xbb7
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c045b828>] lock_acquire+0x94/0xb1
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0736d84>] __mutex_lock_common+0x35/0x2f3
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c07370e0>] mutex_lock_nested+0x30/0x38
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04ec7e5>] __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04eca8e>] blkdev_get+0xa/0xc
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04ecba8>] open_by_devnum+0x20/0x2c
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c046886c>] swsusp_check+0x18/0xf5
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0466287>] software_resume+0xba/0x1f5
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c046643a>] resume_store+0x78/0x88
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c05acb19>] kobj_attr_store+0x1a/0x22
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c050f306>] sysfs_write_file+0xb9/0xe4
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04cc821>] vfs_write+0x84/0xdf
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c04cc915>] sys_write+0x3b/0x60
Apr  7 16:23:45 localhost kernel: [   23.175009]        [<c0738295>] syscall_call+0x7/0xb
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] other info that might help us debug this:
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] 4 locks held by init/1:
Apr  7 16:23:45 localhost kernel: [   23.175009]  #0:  (&buffer->mutex){+.+.+.}, at: [<c050f272>] sysfs_write_file+0x25/0xe4
Apr  7 16:23:45 localhost kernel: [   23.175009]  #1:  (s_active){++++.+}, at: [<c0510544>] sysfs_get_active_two+0x16/0x36
Apr  7 16:23:45 localhost kernel: [   23.175009]  #2:  (s_active){++++.+}, at: [<c051054f>] sysfs_get_active_two+0x21/0x36
Apr  7 16:23:45 localhost kernel: [   23.175009]  #3:  (pm_mutex/1){+.+...}, at: [<c04661f2>] software_resume+0x25/0x1f5
Apr  7 16:23:45 localhost kernel: [   23.175009] 
Apr  7 16:23:45 localhost kernel: [   23.175009] stack backtrace:
Apr  7 16:23:45 localhost kernel: [   23.175009] Pid: 1, comm: init Not tainted 2.6.33.2v0 #2
Apr  7 16:23:45 localhost kernel: [   23.175009] Call Trace:
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0735b79>] ? printk+0xf/0x16
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c045a8a0>] print_circular_bug+0x90/0x9c
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c045b517>] __lock_acquire+0x93a/0xbb7
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c045b828>] lock_acquire+0x94/0xb1
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04ec7e5>] ? __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0736d84>] __mutex_lock_common+0x35/0x2f3
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04ec7e5>] ? __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c05a46c1>] ? exact_match+0x0/0x8
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c07370e0>] mutex_lock_nested+0x30/0x38
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04ec7e5>] ? __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04ec7e5>] __blkdev_get+0x7c/0x31b
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04eca8e>] blkdev_get+0xa/0xc
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04ecba8>] open_by_devnum+0x20/0x2c
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c046886c>] swsusp_check+0x18/0xf5
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0466287>] software_resume+0xba/0x1f5
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0735b79>] ? printk+0xf/0x16
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c046643a>] resume_store+0x78/0x88
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04663c2>] ? resume_store+0x0/0x88
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c05acb19>] kobj_attr_store+0x1a/0x22
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c050f306>] sysfs_write_file+0xb9/0xe4
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c050f24d>] ? sysfs_write_file+0x0/0xe4
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04cc821>] vfs_write+0x84/0xdf
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c04cc915>] sys_write+0x3b/0x60
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0738295>] syscall_call+0x7/0xb
Apr  7 16:23:45 localhost kernel: [   23.175009]  [<c0730000>] ? get_cpu_vendor+0x5d/0x8f

Regards
Richard
