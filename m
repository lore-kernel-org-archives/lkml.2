Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab0FOLn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:43:29 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59245 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab0FOLn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=llvvXk4uZFVccyIkrBAPMCwFLThqSq0jcbb6i/2jBwpKbsJgPDWcjaQCuCv+c7qcKh
         5Rb+poyTI8UyHcZHvgmNWRSivC4puwqmJBHwFPl/p921bQVPWSMmE9SphL6Hl5dp9STJ
         xmjvrP6rsjqetiAcn23WfNvuKrWYulCXfphpE=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 14:35:28 +0300
Message-ID: <AANLkTilkPlNX5-sshrfWMG7teWHTOyf-0CYvv1srZFYh@mail.gmail.com>
Subject: WARNING: at fs/logfs/readwrite.c:902 logfs_seek_hole+0x91/0xa1 
	[logfs]()
From: int 986 <int986@gmail.com>
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When trying to install Debian via deboostrap to logfs loop file get a warning.
Steps to reproduce:
dd if=/dev/zero of=loop.img bs=512 count=2015232
mklogfs -c loop.img                  //mklogfs version 1.1
mount -o loop loop.img  /mnt/ -t logfs
debootstrap unstable /mnt/ http://ftp.bg.debian.org/debian

[  419.086615] ------------[ cut here ]------------
[  419.086636] WARNING: at
/build/buildd-linux-2.6_2.6.34-1~experimental.2-amd64-zn0ozk/linux-2.6-2.6.34/debian/build/source_amd64_none/fs/logfs/readwrite.c:902
logfs_seek_hole+0x91/0xa1 [logfs]()
[  419.086640] Hardware name: VMware Virtual Platform
[  419.086641] Modules linked in: logfs zlib_deflate usb_storage loop
tpm_tis tpm tpm_bios evdev psmouse serio_raw pcspkr parport_pc parport
snd_ens1371 gameport snd_rawmidi snd_seq_device snd_ac97_codec
ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc i2c_piix4
i2c_core shpchp pci_hotplug container button processor ac xfs exportfs
uhci_hcd sg sd_mod crc_t10dif sr_mod cdrom mptspi ata_generic ehci_hcd
usbcore floppy nls_base e1000 mptscsih ata_piix mptbase
scsi_transport_spi libata thermal thermal_sys scsi_mod [last unloaded:
scsi_wait_scan]
[  419.086704] Pid: 4601, comm: tar Not tainted 2.6.34-1-amd64 #1
[  419.086706] Call Trace:
[  419.086740]  [<ffffffff81045655>] ? warn_slowpath_common+0x76/0x8c
[  419.086746]  [<ffffffffa04072bd>] ? logfs_seek_hole+0x91/0xa1 [logfs]
[  419.086751]  [<ffffffffa0404a64>] ? logfs_new_inode+0x7b/0x13b [logfs]
[  419.086756]  [<ffffffffa0402df6>] ? logfs_mkdir+0x16/0x4f [logfs]
[  419.086772]  [<ffffffff810efb8d>] ? vfs_mkdir+0x5b/0xaf
[  419.086775]  [<ffffffff810ef46c>] ? lookup_create+0x4a/0x8e
[  419.086779]  [<ffffffff810f1dad>] ? sys_mkdirat+0x94/0xf6
[  419.086786]  [<ffffffff810fbfb7>] ? mntput_no_expire+0x26/0xe9
[  419.086793]  [<ffffffff810e675f>] ? sys_fchmodat+0xbe/0xcd
[  419.086796]  [<ffffffff810fbfb7>] ? mntput_no_expire+0x26/0xe9
[  419.086806]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b
[  419.086809] ---[ end trace f10931bdbea823c6 ]---
