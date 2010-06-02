Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab0FBXFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:05:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58101 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab0FBXFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R/InQktcjJS0BeGOo/6vKbXRmqCeYfdsCerLCVL3XkxprYrhvRmNW8akEEtPtqjiPP
         wEN5E6FNWxAkAYjB9YyQJGw4SGjrC0rYO1QnmBlLXj4nSlMUnlBjIm5znf5byo63lrc9
         MJcF3iTBzIGvQPBVefZDhzinrRv4jWZH3GZrc=
MIME-Version: 1.0
In-Reply-To: <201006021510.52463.tfjellstrom@strangesoft.net>
References: <201005292046.06344.tfjellstrom@strangesoft.net>
	<201005301348.50004.tfjellstrom@strangesoft.net>
	<201005301919.16747.tfjellstrom@strangesoft.net>
	<201006021510.52463.tfjellstrom@strangesoft.net>
Date: Wed, 2 Jun 2010 17:05:28 -0600
Message-ID: <AANLkTingFbJAr9z0AzRJCV23FGVS-UAvIKCr5ULQJawt@mail.gmail.com>
Subject: Re: failed command FLUSH CACHE EXT (was: Re: via 8237 sata errors)
From: Robert Hancock <hancockrwd@gmail.com>
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 3:10 PM, Thomas Fjellstrom
<tfjellstrom@strangesoft.net> wrote:
> Ok, more testing, I've moved the drives over to the p35 machine semi-
> permanently, and after a day or so of uptime I got some new errors:
>
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> ata3.00: failed command: FLUSH CACHE EXT
> ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata3.00: status: { DRDY }
> ata3: hard resetting link
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
> ata3: hard resetting link
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
> ata3: hard resetting link
> ata3: link is slow to respond, please be patient (ready=0)
> ata3: SRST failed (errno=-16)
> ata3: limiting SATA link speed to 1.5 Gbps
> ata3: hard resetting link
> ata3: SRST failed (errno=-16)
> ata3: reset failed, giving up
> ata3.00: disabled
> ata3.00: device reported invalid CHS sector 0
> ata3: EH complete
> end_request: I/O error, dev sdc, sector 0
> sd 2:0:0:0: [sdc] Unhandled error code
> sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 2:0:0:0: [sdc] CDB: Write(10): 2a 00 00 00 07 a7 00 00 08 00
> end_request: I/O error, dev sdc, sector 1959
> Buffer I/O error on device dm-0, logical block 189
> lost page write due to I/O error on dm-0
> end_request: I/O error, dev sdc, sector 0
> end_request: I/O error, dev sdc, sector 0
> JBD2 unexpected failure: do_get_write_access: buffer_uptodate(jh2bh(jh));
> Possible IO failure.
>
> end_request: I/O error, dev sdc, sector 0
> end_request: I/O error, dev sdc, sector 0
> ------------[ cut here ]------------
> WARNING: at /home/damentz/src/zen/main/linux-
> liquorix-2.6-2.6.34/debian/build/source_amd64_none/fs/buffer.c:1199
> mark_buffer_dirty+0x74/0x90()
> Hardware name: P5K SE
> Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6
> acpi_cpufreq cpufreq_ondemand freq_table cpufreq_conservative
> cpufreq_userspace cpufreq_powersave af_packet ext3 jbd loop
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
> snd_mixer_oss snd_pcm rtc_cmos rtc_core snd_timer tpm_tis nvidia(P) tpm
> rtc_lib tpm_bios evdev snd intel_agp pcspkr asus_atk0110 soundcore i2c_i801
> snd_page_alloc button i2c_core processor dm_mod raid10 raid456
> async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
> raid1 raid0 multipath linear md_mod ext4 mbcache jbd2 crc16 usbhid sd_mod
> ata_generic pata_acpi uhci_hcd ata_piix libata floppy scsi_mod thermal atl1
> mii ehci_hcd [last unloaded: scsi_wait_scan]
> Pid: 3283, comm: jbd2/dm-0-8 Tainted: P           2.6.34-0.dmz.8-liquorix-
> amd64 #1
> Call Trace:
>  [<ffffffff8103bf23>] ? warn_slowpath_common+0x73/0xb0
>  [<ffffffff81101cd4>] ? mark_buffer_dirty+0x74/0x90
>  [<ffffffffa005a3c9>] ? __jbd2_journal_unfile_buffer+0x9/0x20 [jbd2]
>  [<ffffffffa005d8a3>] ? jbd2_journal_commit_transaction+0xba3/0x12d0 [jbd2]
>  [<ffffffff810542d0>] ? autoremove_wake_function+0x0/0x30
>  [<ffffffffa0061701>] ? kjournald2+0xb1/0x210 [jbd2]
>  [<ffffffff810542d0>] ? autoremove_wake_function+0x0/0x30
>  [<ffffffffa0061650>] ? kjournald2+0x0/0x210 [jbd2]
>  [<ffffffff81053e3e>] ? kthread+0x8e/0xa0
>  [<ffffffff81033e8d>] ? schedule_tail+0x4d/0xf0
>  [<ffffffff81003c94>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff81053db0>] ? kthread+0x0/0xa0
>  [<ffffffff81003c90>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace c90e4c710c9ef513 ]---
> end_request: I/O error, dev sdc, sector 0
>
> (and plenty more dmesg lines from lvm and ext4/jbd2 screaming about the io
> commands failing)
>
> I take it that this means the drive is likely pooched? I'm going to try some
> more tests, and make sure both of the WD drives are on their own power cable
> first. but I'm betting now that the drive is just failing. This would make 2
> out of 4 in the same batch that had issues. The first one would increase the
> sector reallocated count 4 every hour or so. Now this one fails a flush
> cache command (and other spurious errors).
>
> I guess its time to break out the WD diagnostics disk.

I think it's a fairly safe assumption there's something wrong with the
drive - it looks like the drive just pretty much stopped talking..
