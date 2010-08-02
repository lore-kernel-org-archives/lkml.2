Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0HBCbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:31:15 -0400
Received: from phil.doycomm.com ([66.219.128.249]:53339 "EHLO phil.doycomm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0HBCbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:31:14 -0400
Subject: Re: Linux 2.6.35
From: Donald Parsons <dparsons@brightdsl.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Aug 2010 22:31:02 -0400
Message-ID: <1280716262.5125.42.camel@falcon.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35 still fails to boot for me, as first reported here:
 http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html

I've manually bisected it down to around May 20 between
  2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.

Unfortunately first time I tried was with 2.6.35-rc6 and
it failed to boot.

Failure when switching from initramfs to real /root?
Removing kernel "quiet" param appears to show several
lines listing:

  usb drives/hubs? followed by
  dracut switching root (when booting works)
              or
  usb drives/hubs? followed by
        (missing dracut... line)
  No root device found
  Boot has failed, sleeping forever.   (when it does not boot)

Grub, typical entry:
title Fedora (2.6.35)
	root (hd0,0)
	kernel /vmlinuz-2.6.35 ro
root=UUID=686dc496-8814-4c36-8fb7-5ded2916e825 rhgb
SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 KEYTABLE=us
rdblacklist=nouveau init=/sbin/bootchartd
	initrd /initramfs-2.6.35.img


My boot failure seems to be different than other two reported
in the thread "2.6.35-rc6-git6: Reported regressions from 2.6.34"
under Bug #16173 and #16228
 http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/00080.html

System is up to date Fedora 12 on Asus P5B Deluxe, Core2 6600 2.4GHz

00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH)
    6 port SATA AHCI Controller (rev 02)
01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7600
    GT] (rev a1)
03:00.0 SATA controller: JMicron Technologies, Inc. 20360/20363 Serial
    ATA Controller (rev 02)

Using 2.6.34.1 shows
# lsmod | grep ata
ata_generic             3427  0 
pata_acpi               3227  0 
pata_jmicron            2547  0 
libata                157450  4 ata_generic,pata_acpi,pata_jmicron,ahci
scsi_mod              147895  5 sg,sd_mod,sr_mod,usb_storage,libata

The .config's were made from 2.6.34.1/.config using oldconfig and enter
key (defaults for any questions).

Updating BIOS from 1232 to 1238 (latest) gave no change.
Tried gcc's 4.4.4, 4.5.0, and 4.5.1 with no change.

Thanks for any help,
Don

