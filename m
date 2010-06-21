Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0FUOey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:34:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41278 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab0FUOev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bx/J7C/YIv1MnAYFquz8wI3To+CvLIrXQT8f+yb0L8rDuX/QLGLzWdnd1IZ3vAYjul
         MMFE81fLFIC4zBg3uZ5qKo9THAuwD0ek06xvzGAUfslADlhep1zzAnOb25dQtHcaHl0U
         vP7TTluZC7YE7hFjE0HEJVAuWILx+OPmfsLbA=
MIME-Version: 1.0
In-Reply-To: <AANLkTilkPlNX5-sshrfWMG7teWHTOyf-0CYvv1srZFYh@mail.gmail.com>
References: <AANLkTilkPlNX5-sshrfWMG7teWHTOyf-0CYvv1srZFYh@mail.gmail.com>
Date: Mon, 21 Jun 2010 17:34:48 +0300
Message-ID: <AANLkTilCE1yLvwcw-b81wsxIk3ZfMAOXonzyaxQiiK4P@mail.gmail.com>
Subject: Re: WARNING: at fs/logfs/readwrite.c:902 logfs_seek_hole+0x91/0xa1 
	[logfs]()
From: int 986 <int986@gmail.com>
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Tue, Jun 15, 2010 at 2:35 PM, int 986 <int986@gmail.com> wrote:
> Hi,
> When trying to install Debian via deboostrap to logfs loop file get a warning.
> Steps to reproduce:
> dd if=/dev/zero of=loop.img bs=512 count=2015232
> mklogfs -c loop.img                  //mklogfs version 1.1
> mount -o loop loop.img  /mnt/ -t logfs
> debootstrap unstable /mnt/ http://ftp.bg.debian.org/debian
>
> [  419.086615] ------------[ cut here ]------------
> [  419.086636] WARNING: at
> /build/buildd-linux-2.6_2.6.34-1~experimental.2-amd64-zn0ozk/linux-2.6-2.6.34/debian/build/source_amd64_none/fs/logfs/readwrite.c:902
> logfs_seek_hole+0x91/0xa1 [logfs]()
> [  419.086640] Hardware name: VMware Virtual Platform
> [  419.086641] Modules linked in: logfs zlib_deflate usb_storage loop
> tpm_tis tpm tpm_bios evdev psmouse serio_raw pcspkr parport_pc parport
> snd_ens1371 gameport snd_rawmidi snd_seq_device snd_ac97_codec
> ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc i2c_piix4
> i2c_core shpchp pci_hotplug container button processor ac xfs exportfs
> uhci_hcd sg sd_mod crc_t10dif sr_mod cdrom mptspi ata_generic ehci_hcd
> usbcore floppy nls_base e1000 mptscsih ata_piix mptbase
> scsi_transport_spi libata thermal thermal_sys scsi_mod [last unloaded:
> scsi_wait_scan]
> [  419.086704] Pid: 4601, comm: tar Not tainted 2.6.34-1-amd64 #1
> [  419.086706] Call Trace:
> [  419.086740]  [<ffffffff81045655>] ? warn_slowpath_common+0x76/0x8c
> [  419.086746]  [<ffffffffa04072bd>] ? logfs_seek_hole+0x91/0xa1 [logfs]
> [  419.086751]  [<ffffffffa0404a64>] ? logfs_new_inode+0x7b/0x13b [logfs]
> [  419.086756]  [<ffffffffa0402df6>] ? logfs_mkdir+0x16/0x4f [logfs]
> [  419.086772]  [<ffffffff810efb8d>] ? vfs_mkdir+0x5b/0xaf
> [  419.086775]  [<ffffffff810ef46c>] ? lookup_create+0x4a/0x8e
> [  419.086779]  [<ffffffff810f1dad>] ? sys_mkdirat+0x94/0xf6
> [  419.086786]  [<ffffffff810fbfb7>] ? mntput_no_expire+0x26/0xe9
> [  419.086793]  [<ffffffff810e675f>] ? sys_fchmodat+0xbe/0xcd
> [  419.086796]  [<ffffffff810fbfb7>] ? mntput_no_expire+0x26/0xe9
> [  419.086806]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b
> [  419.086809] ---[ end trace f10931bdbea823c6 ]---
>
