Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1GLUwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:52:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39065 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1GLUwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:52:00 -0400
MIME-Version: 1.0
Date: Tue, 12 Jul 2011 22:51:58 +0200
Message-ID: <CAPJ9Yc-Rce8sSjuLUrA+fsUvFOGdpb4AsPMdjydWq52dbL19aQ@mail.gmail.com>
Subject: Cause of RAMDISK: incomplete write error ?
From: =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Recently I encountered this error when booting from an USB flash drive:
RAMDISK: incomplete write (404 != 29094)
write error
UDF-fs: No partition found (1)
(followed by panic)

According to kernel source, this is a problem in the write() call:

(v2.6.39/init/do_mounts_rd.c , line 318)
static int __init compr_flush(void *window, unsigned int outcnt)
{
        int written = sys_write(crd_outfd, window, outcnt);
        if (written != outcnt) {
                if (decompress_error == 0)
                        printk(KERN_ERR
                               "RAMDISK: incomplete write (%d != %d)\n",
                               written, outcnt);

I use grub4DOS on a NTFS formatted USB drive for booting.
The menu.lst entry is:

title xxx test RL13.5  xxxx Boot Linux system! (32-bit kernel)
pause --wait=0 Loading kernel32...
kernel /kernel32 root=/dev/ram0 rw vga=normal video=640x400
pause --wait=0 Loading rootfs.cgz... This could take a couple of minutes.
initrd /rootfs.cgz

The same problem happens on two PCs, one HP N36L microserver and the
other an Asus EEE PC 1005HA netbook (booting the same USB drive).

Could it be, that the initrd image is somehow to big, hitting some limit?

This is the RIPLinux mini distro. I encountered this problem a few
versions back. I suspect the image size, as it
gets bigger from release to release.
Currently it is 147.790.634 bytes big.

Booting the same files from a CD works, but that uses a different
bootloader (distro official ISO image, uses isolinux, I think).

The problem I am describing is with RIPLinux release 13.5, I used the
files from this download:
http://rip.7bf.de/current/RIPLinuX-13.5.iso
(I guess they will move it after a while to
http://rip.7bf.de/all_mirrored_versions/ )

So, can please someone point me in a direction, where the problem could lie?

Checking the initrd image file with gzip gives an OK.

Regards,
David
