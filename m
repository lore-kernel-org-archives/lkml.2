Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0KXOeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:34:14 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34889 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab0KXOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pts9iT8qekIj8DcMWpXvmVcs5/zyQQwDFyweptLmgIiTL6+jc25q8sOiPphLt5kF5i
         2OnnxflmqMxJYlAWo4ZkZiAMV3saZ7arcKn801qX5VNNkv4/otF/+pOj1WRQOtyTLiwT
         M3N6z+OrOcfBaHa3KOb2CM9uOMhI1Ivt1zbQs=
Message-ID: <4CED2251.3020708@suse.cz>
Date: Wed, 24 Nov 2010 15:33:53 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sergey Lapin <slapin@ossfans.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: ldisc problems with 2.6.32-2.6.37-rc2 (at least)
References: <20101124135249.GA7282@build.ihdev.net>
In-Reply-To: <20101124135249.GA7282@build.ihdev.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 02:52 PM, Sergey Lapin wrote:
> slapin@slapin:~$ dmesg
>  Sent at 4:45 PM on Wednesday
>  me:  [2943389.061987] ------------[ cut here ]----------
> [2943389.062002] WARNING: at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/drivers/char/tty_ldisc.c:445 tty_ldisc_open+0x26/0x38()
> [2943389.062008] Hardware name: System Product Name
> [2943389.062011] Modules linked in: x25 ax25 x25_asy lapb cp210x btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs exportfs reiserfs ext4 jbd2 nls_cp437 vfat fat usb_storage nls_utf8 isofs udf crc_itu_t acpi_cpufreq sco parport_pc cpufreq_stats bridge ppdev cpufreq_conservative stp cpufreq_userspace lp cpufreq_powersave parport vboxnetadp bnep rfcomm vboxnetflt l2cap vboxdrv crc16 bluetooth rfkill binfmt_misc fuse ext2 loop snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device i915 drm_kms_helper evdev drm i2c_i801 i2c_algo_bit snd psmouse pl2303 video soundcore joydev asus_atk0110 output usbserial i2c_core snd_page_alloc pcspkr processor button serio_raw ext3 jbd mbcache usbhid hid dm_mod sg sr_mod sd_mod crc_t10dif cdrom ata_generic ata_piix ehci_hcd thermal r8169 pata_jmicron thermal_sys libata scsi_m
od mii usbcore nls_base [last unloaded: x25]
> [2943389.062162] Pid: 5251, comm: a.out Tainted: G        W  2.6.32-5-686 #1
> [2943389.062167] Call Trace:
> [2943389.062180]  [<c1030321>] ? warn_slowpath_common+0x5e/0x8a
> [2943389.062188]  [<c1030357>] ? warn_slowpath_null+0xa/0xc
> [2943389.062195]  [<c119311c>] ? tty_ldisc_open+0x26/0x38
> [2943389.062202]  [<c11936c5>] ? tty_set_ldisc+0x218/0x304
> [2943389.062212]  [<c101f409>] ? kunmap_atomic+0x51/0x6d
> [2943389.062230]  [<f852ee80>] ? usb_serial_generic_chars_in_buffer+0x75/0x9c [usbserial]
> [2943389.062244]  [<f852d0df>] ? serial_chars_in_buffer+0x44/0x47 [usbserial]
> [2943389.062252]  [<c1191f0e>] ? tty_chars_in_buffer+0x12/0x13
> [2943389.062259]  [<c119231a>] ? tty_wait_until_sent+0x1c/0xcb
> [2943389.062271]  [<c118efa1>] ? tty_ioctl+0x554/0x6f0
> [2943389.062277]  [<c118ea4d>] ? tty_ioctl+0x0/0x6f0
> [2943389.062287]  [<c10bd3cc>] ? vfs_ioctl+0x1c/0x5f
> [2943389.062294]  [<c10bd960>] ? do_vfs_ioctl+0x4aa/0x4e5
> [2943389.062303]  [<c10b1453>] ? do_sys_open+0xd4/0xdf
> [2943389.062309]  [<c10adfb0>] ? kmem_cache_free+0x78/0xaf
> [2943389.062316]  [<c10b1453>] ? do_sys_open+0xd4/0xdf
> [2943389.062323]  [<c10b1448>] ? do_sys_open+0xc9/0xdf
> [2943389.062331]  [<c126f01f>] ? do_page_fault+0x2f1/0x307
> [2943389.062339]  [<c10bd9dc>] ? sys_ioctl+0x41/0x58
> [2943389.062347]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
> [2943389.062353] ---[ end trace a7919e7f17c0a72e ]---
> 
> What am I doing wrong here? This backtrace is from Debian
> slapin@slapin:~$ uname -a
> Linux slapin 2.6.32-5-686 #1 SMP Thu Oct 14 17:15:16 UTC 2010 i686 GNU/Linux
> 
> But I get similar backtraces from 2.6.37-rc2.

Hi, I don't think you get similar backtraces in .37-rc2. Could you grab one?

regards,
-- 
js
suse labs
