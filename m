Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1BGSVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:21:18 -0500
Received: from 84-16-211.226.3p.ntebredband.no ([84.16.211.226]:41550 "EHLO
	mail.aptomar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGSVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:21:16 -0500
Date: Mon, 7 Feb 2011 19:20:58 +0100 (CET)
From: Rune Saetre <rune.saetre@aptomar.com>
X-X-Sender: rst@pingle.local.rsnet
To: linux-kernel@vger.kernel.org
cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Rune Saetre <rune.saetre@aptomar.com>
In-Reply-To: <Pine.LNX.4.64.1101191245150.15860@pingle.local.rsnet>
Message-ID: <Pine.LNX.4.64.1102071918200.6709@pingle.local.rsnet>
References: <Pine.LNX.4.64.1101171420420.15860@pingle.local.rsnet>
 <Pine.LNX.4.64.1101180213130.15860@pingle.local.rsnet> <4D35BC4B.50108@gmail.com>
 <201101181730.52239.hverkuil@xs4all.nl> <4D36B81B.9000602@gmail.com>
 <Pine.LNX.4.64.1101191245150.15860@pingle.local.rsnet>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="279707905-1041716834-1297102858=:6709"
X-SA-Exim-Connect-IP: 84.16.211.227
X-SA-Exim-Mail-From: rune.saetre@aptomar.com
Subject: Re: PROBLEM: kernel BUG at drivers/media/video/em28xx/em28xx-video.c:891
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on mail.aptomar.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--279707905-1041716834-1297102858=:6709
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi

The STREAMOFF issue has not appeared after having tested with kernel=20
version 2.6.38-rc2 for a while. I am happy :-)

Regards
Rune

--=20
We are proud to present our new web-pages at www.aptomar.com
Do not miss our video-window to the world; aptotube

Rune S=E6tre <rune.saetre@aptomar.com>
aptomar as

www.aptomar.com


On Wed, 19 Jan 2011, Rune Saetre wrote:

> Hi
>
> Yes. I will try it out and post a message as soon as I have some experien=
ce=20
> with it.
>
> Regards
> Rune
>
> --=20
> We are proud to present our new web-pages at www.aptomar.com
> Do not miss our video-window to the world; aptotube
>
> Rune S=E6tre <rune.saetre@aptomar.com>
> aptomar as
>
> www.aptomar.com
>
>
> On Wed, 19 Jan 2011, Patrik Jakobsson wrote:
>
>> On 01/18/2011 05:30 PM, Hans Verkuil wrote:
>>> On Tuesday, January 18, 2011 17:14:03 Patrik Jakobsson wrote:
>>>> Hello Rune
>>>>=20
>>>> I'm trying to learn more about the linux kernel so I figured helping
>>>> with bugs is a good way to get started.
>>>>=20
>>>> On 01/18/2011 02:20 AM, Rune Saetre wrote:
>>>>> Hi
>>>>>=20
>>>>> The crash is not as consistent as I first believed. I have managed to
>>>>> stop and start capturing several (but not many) times without the
>>>>> driver crashing now.
>>>>>=20
>>>> To me it seems that the resource locking (functions res_get, res_check=
,
>>>> res_locked and res_free) is subject to race condition.
>>>>=20
>>>> I looked at older versions of the code and found that there used to be
>>>> locks around some of these pieces. It was removed in commit:
>>>>=20
>>>> 0499a5aa777f8e56e46df362f0bb9d9d116186f9 - V4L/DVB: em28xx: remove BKL
>>>>=20
>>>> Other V4L drivers use pretty much the same code (res_get, res_free,
>>>> etc.) for resource locking but still have the mutex_lock/unlock around
>>>> it. Does anyone know why this was removed?
>>> Because now the video4linux core does the locking.
>>>=20
>>> Anyway, I'm pretty sure this is the bug that was fixed here:
>>>=20
>>> http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09413.html
>>>=20
>>> This fix will be in 2.6.38.
>>>=20
>>> The change in the locking mechanism had nothing to do this particular b=
ug.
>>> It was just incorrect administration of resources.
>>>=20
>>> Regards,
>>>
>>> =09Hans
>>>=20
>> Thanks for the explanation. I see now how the V4L core locks around the=
=20
>> ioctls. The member unlocked_ioctl of struct v4l2_file_operations confuse=
d=20
>> me a little. Maybe serialized_ioctl would be a better name? Not a big is=
sue=20
>> though.
>>=20
>> Hopefully the patch fixes your problem Rune.
>>=20
>> Thanks
>> Patrik Jakobsson
>>=20
>>>> Thanks
>>>> Patrik Jakobsson
>>>>> The trace logs also differ slightly. Here is the last one:
>>>>>=20
>>>>> Jan 18 02:12:08 mate kernel: [  117.219326] ------------[ cut here
>>>>> ]------------
>>>>> Jan 18 02:12:08 mate kernel: [  117.219412] kernel BUG at
>>>>> drivers/media/video/em28xx/em28xx-video.c:891!
>>>>> Jan 18 02:12:08 mate kernel: [  117.219507] invalid opcode: 0000 [#1]
>>>>> PREEMPT SMP Jan 18 02:12:08 mate kernel: [  117.219597] last sysfs
>>>>> file: /sys/devices/virtual/block/dm-8/stat
>>>>> Jan 18 02:12:08 mate kernel: [  117.219681] CPU 1 Jan 18 02:12:08 mat=
e
>>>>> kernel: [  117.219714] Modules linked in: acpi_cpufreq mperf
>>>>> cpufreq_powersave cpufreq_stats cpufreq_userspace cpufreq_conservativ=
e
>>>>> ppdev lp nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs binfmt_misc
>>>>> fuse dummy bridge stp ext2 mbcache coretemp kvm_intel kvm loop
>>>>> firewire_sbp2 tuner snd_hda_codec_realtek arc4 snd_hda_intel
>>>>> snd_usb_audio snd_hda_codec ecb snd_seq_dummy snd_pcm_oss
>>>>> snd_mixer_oss saa7115 snd_pcm ir_lirc_codec lirc_dev ir_sony_decoder
>>>>> snd_hwdep snd_usbmidi_lib em28xx ir_jvc_decoder ir_rc6_decoder
>>>>> snd_seq_oss snd_seq_midi snd_rawmidi r8169 ir_rc5_decoder mii
>>>>> ir_nec_decoder snd_seq_midi_event i915 v4l2_common iwlagn iwlcore
>>>>> snd_seq ir_core drm_kms_helper drm videobuf_vmalloc snd_timer
>>>>> snd_seq_device videobuf_core pcmcia joydev mac80211 uvcvideo videodev
>>>>> v4l1_compat v4l2_compat_ioctl32 tveeprom cfg80211 rfkill i2c_i801
>>>>> i2c_algo_bit tpm_tis tpm yenta_socket snd intel_agp shpchp pci_hotplu=
g
>>>>> video output pcmcia_rsrc wmi pcmcia_core soundcore snd_page_alloc
>>>>> parport_pc parport i2c_cor
>>>>> Jan 18 02:12:08 mate kernel:  irda tpm_bios intel_gtt pcspkr crc_ccit=
t
>>>>> psmouse evdev serio_raw container processor battery ac button reiserf=
s
>>>>> dm_mod raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor
>>>>> xor async_memcpy async_tx raid1 raid0 multipath linear md_mod
>>>>> ide_cd_mod cdrom sd_mod ata_generic pata_acpi ata_piix crc_t10dif
>>>>> ide_pci_generic ahci libahci sdhci_pci firewire_ohci sdhci libata
>>>>> scsi_mod piix ide_core firewire_core mmc_core uhci_hcd tg3 thermal
>>>>> crc_itu_t thermal_sys ehci_hcd [last unloaded: scsi_wait_scan]
>>>>> Jan 18 02:12:08 mate kernel: [  117.220091] Jan 18 02:12:08 mate
>>>>> kernel: [  117.220091] Pid: 3154, comm: camera_factory_ Not tainted
>>>>> 2.6.37-rst #1 Victoria        /TravelMate 6292 Jan 18 02:12:08 mate
>>>>> kernel: [  117.220091] RIP: 0010:[<ffffffffa05a37f4>]
>>>>> [<ffffffffa05a37f4>] res_free+0x14/0x49 [em28xx]
>>>>> Jan 18 02:12:08 mate kernel: [  117.220091] RSP:
>>>>> 0018:ffff8800794a1c48  EFLAGS: 00010297
>>>>> Jan 18 02:12:08 mate kernel: [  117.220091] RAX: 0000000000000001 RBX=
:
>>>>> ffff88007b94dc00 RCX: 0000000000000000
>>>>> Jan 18 02:12:08 mate kernel: [  117.220091] RDX: 0000000000000000 RSI=
:
>>>>> ffff8800378e7000 RDI: ffff88007b94dc00
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] RBP: ffff8800378e7000 R08=
:
>>>>> 0000000000000001 R09: 0000000000000c52
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] R10: 0000000000000000 R11=
:
>>>>> 0000000000000246 R12: 0000000000000000
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] R13: ffffffffa05ab920 R14=
:
>>>>> ffff88006dd123c0 R15: ffff88007b94dc00
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] FS:
>>>>> 00007f37105bb820(0000) GS:ffff88007f500000(0000) knlGS:00000000000000=
00
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] CS:  0010 DS: 0000 ES:
>>>>> 0000 CR0: 0000000080050033
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] CR2: 000000000378b248 CR3=
:
>>>>> 000000007a079000 CR4: 00000000000006e0
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] DR0: 0000000000000000 DR1=
:
>>>>> 0000000000000000 DR2: 0000000000000000
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] DR3: 0000000000000000 DR6=
:
>>>>> 00000000ffff0ff0 DR7: 0000000000000400
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] Process camera_factory_
>>>>> (pid: 3154, threadinfo ffff8800794a0000, task ffff880071f6d820)
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] Stack:
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  ffff8800378e7000
>>>>> ffffffffa05a46b9 ffff88007a2fd040 ffffffff81042cf3
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  0000000000000001
>>>>> ffffffff00000001 ffffffff8103dadb 0000000000000001
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  ffff88007ba3e400
>>>>> ffffffffa03302ff 00000000000135c0 00000000000135c0
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] Call Trace:
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffffa05a46b9>] ?
>>>>> vidioc_streamoff+0xa6/0xb6 [em28xx]
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81042cf3>] ?
>>>>> get_parent_ip+0x9/0x1b
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff8103dadb>] ?
>>>>> need_resched+0x1a/0x23
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffffa03302ff>] ?
>>>>> __video_do_ioctl+0x12e2/0x33a0 [videodev]
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff8103a5fe>] ?
>>>>> __wake_up_common+0x41/0x78
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff8103da1b>] ?
>>>>> __wake_up+0x35/0x46
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81042cf3>] ?
>>>>> get_parent_ip+0x9/0x1b
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81044d80>] ?
>>>>> add_preempt_count+0x9e/0xa0
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff8132935c>] ?
>>>>> _raw_spin_lock_irqsave+0x40/0x61
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffffa03326f4>] ?
>>>>> video_ioctl2+0x2ad/0x35d [videodev]
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81042cf3>] ?
>>>>> get_parent_ip+0x9/0x1b
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffffa032e342>] ?
>>>>> v4l2_ioctl+0x74/0x113 [videodev]
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81106f51>] ?
>>>>> do_vfs_ioctl+0x418/0x465
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81106fda>] ?
>>>>> sys_ioctl+0x3c/0x5e
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  [<ffffffff81009c52>] ?
>>>>> system_call_fastpath+0x16/0x1b
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091] Code: 03 4c 39 e3 0f 18 0=
8
>>>>> 75 d4 31 c0 eb 05 b8 ea ff ff ff 5b 5d 41 5c c3 48 83 ec 08 8b 57 0c
>>>>> 89 f0 89 c1 48 8b 37 21 d1 39 c1 74 04<0f>  0b eb fe 89 c8 f7 d0 21 c=
2
>>>>> 89 57 0c 21 86 d0 09 00 00 83 3d Jan 18 02:12:09 mate kernel: [
>>>>> 117.220091] RIP  [<ffffffffa05a37f4>] res_free+0x14/0x49 [em28xx]
>>>>> Jan 18 02:12:09 mate kernel: [  117.220091]  RSP<ffff8800794a1c48>
>>>>> Jan 18 02:12:09 mate kernel: [  117.264998] ---[ end trace
>>>>> 6d6576ecd99356c8 ]---
>>>>>=20
>>>>> I hope this helps.
>>>>>=20
>>>>> Regards
>>>>> Rune
>>>>>=20
>>>>>=20
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media"=
 in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>=20
>>=20
>
--279707905-1041716834-1297102858=:6709--
