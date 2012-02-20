Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2BTBPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:15:48 -0500
Received: from nm16.access.bullet.mail.sp2.yahoo.com ([98.139.44.143]:36568
	"HELO nm16.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751783Ab2BTBPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:15:47 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 20:15:47 EST
X-Yahoo-Newman-Id: 186274.16492.bm@omp1005.access.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:From:To:Subject:Date:Message-ID:Organization:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=zff0tyEETwwyCpTdAFogKx9nT+IjGIUtQnSW7UXAjl7xcT8WCvqWei5YynI29PLMcZCLo2SQqyXd1m+5d5LLGRa9gb8Qi0f4CkmbKVXZAejIVLIGLZcf91Bt33ZJAlCJiWItX2S8MhoULCnwXj6GYQz7Kiq2sGAQ9k1XOPSt76I=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: VVMcLHUVM1khwjblFgZ6XX6ARmsv0XQVANzm9ZotSDF4JAS
 v7i0FPc_hOERWAcmgWRCcxwGpC1G1jPDyuE_jrMqsQIe_XAtpAdfI6ggho.O
 ROoBjTjP6fIdcqT.6Y83GPGO8IjFo3vdoXHCvwGIxxWMNXwlxosrTlJGQ6J9
 5hrtZdKjoicMkj2axNUOZqtE_2ivRKkuDJ5LdXJRjbPajuhmhUGFZo.9s8um
 RKbeaXzvGZmUss3MtHotUgS2HdTLx2ylf5oIBaH0Uvfl8xQeRU5OKLFU3IMi
 KwBBkpersZIPHcIjYEuvywuDBR3fa4WmyZ3h5JXoHCp.ymYsa3QX34CnT4Hc
 cBSJrrMnBGO6EaW7clkuB2NNx.IsCEvHFXbidGOEAqvdAXLr3JMwJbcuD6wq
 d4HprVjNrNsEhCqMg4cpU9o5tk5A4A1Q1JspgeTjWuuz8jYYFi8G4KeXAcJm
 LIZ_IyDjQqFpglUP5GtEkECH3xrO4lSTKy.YQUPQLjWK2JWYfu1yJRbHVyAE
 iOlCMaLaHxvMf01scdAru7F_OBk4zbmg77BZdPQXazL.BBZcnF3b3U9_EoqZ
 PcpUD9eqGD9g5wkyFh1teKQPipw--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [3.3.0-rc3][uvcvideo][regression] oops - uvc_video_clock_update
Date: Sun, 19 Feb 2012 20:08:51 -0500
Message-ID: <5887142.ZMTDAjc4qf@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.8.0 (Linux/3.3.0-0.rc3.git6.2.fc18.x86_64; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, I've been able to trigger this. If using a webcam in Firefox with a 
flash plugin, when trying turn off cam, panic dumps to console (X switches to 
console). 

This was fine in 3.2/3.1 series.

Linux segfault.sh0n.net 3.3.0-0.rc3.git6.2.fc18.x86_64 #1 SMP Thu Feb 16 
00:14:39 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Aside from VirtualBox being loaded - and not using video - I can trigger this 
without VirtualBox loaded also. the stack clearly shows bug in uvc driver.

oops below:

[ 2007.719508] BUG: unable to handle kernel NULL pointer dereference at 
00000000000000a4
[ 2007.720401] IP: [<ffffffffa04d83f2>] uvc_video_clock_update+0x72/0x3a0 
[uvcvideo]
[ 2007.720401] PGD 133bdd067 PUD 13357d067 PMD 0 
[ 2007.720401] Oops: 0000 [#1] SMP 
[ 2007.720401] CPU 1 
[ 2007.720401] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) 
vboxdrv(O) lockd sunrpc coretemp uvcvideo videobuf2_core videodev media 
v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device arc4 snd_hda_codec_conexant iwlwifi 
mac80211 snd_hda_intel i2c_i801 thinkpad_acpi cfg80211 snd_hda_codec snd_hwdep 
snd_pcm snd_timer snd_page_alloc rfkill microcode r592 memstick snd soundcore 
serial_cs e1000e iTCO_wdt iTCO_vendor_support binfmt_misc virtio_net kvm_intel 
kvm sdhci_pci sdhci mmc_core firewire_ohci firewire_core crc_itu_t 
yenta_socket wmi video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core 
[last unloaded: scsi_wait_scan]
[ 2007.720401] 
[ 2007.720401] Pid: 3337, comm: plugin-containe Tainted: G        WC O 
3.3.0-0.rc3.git6.2.fc18.x86_64 #1 LENOVO 4058CTO/4058CTO
[ 2007.720401] RIP: 0010:[<ffffffffa04d83f2>]  [<ffffffffa04d83f2>] 
uvc_video_clock_update+0x72/0x3a0 [uvcvideo]
[ 2007.720401] RSP: 0018:ffff8800650c1ad8  EFLAGS: 00010006
[ 2007.720401] RAX: 0000000000000000 RBX: 00000000000000a0 RCX: 
0000000000000020
[ 2007.720401] RDX: 0000000000000004 RSI: 00000000312a0c44 RDI: 
0000000000000046
[ 2007.720401] RBP: ffff8800650c1ba8 R08: 0000000000000001 R09: 
0000000000000001
[ 2007.720401] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff880132f3b800
[ 2007.720401] R13: ffff88006279f000 R14: ffff880132f3bf20 R15: 
ffff88006279f000
[ 2007.720401] FS:  00007fd4fc1ff700(0000) GS:ffff880137000000(0000) 
knlGS:0000000000000000
[ 2007.720401] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2007.720401] CR2: 00000000000000a4 CR3: 000000010a894000 CR4: 
00000000000426e0
[ 2007.720401] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2007.720401] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 2007.720401] Process plugin-containe (pid: 3337, threadinfo 
ffff8800650c0000, task ffff88012eb14a80)
[ 2007.720401] Stack:
[ 2007.720401]  0000000000000000 0000000000000000 0000000000000002 
0000000000000000
[ 2007.720401]  ffff8800650c1b78 0000000000000046 0000000000000000 
ffffffffa04c9750
[ 2007.720401]  0000000000000000 0000000000000000 ffff8800650c1b78 
0000000000000046
[ 2007.720401] Call Trace:
[ 2007.720401]  [<ffffffffa04c9750>] ? vb2_dqbuf+0x220/0x3e0 [videobuf2_core]
[ 2007.720401]  [<ffffffffa04d3e26>] uvc_buffer_finish+0x26/0x30 [uvcvideo]
[ 2007.720401]  [<ffffffffa04c978f>] vb2_dqbuf+0x25f/0x3e0 [videobuf2_core]
[ 2007.720401]  [<ffffffffa04d4207>] ? uvc_dequeue_buffer+0x37/0x70 [uvcvideo]
[ 2007.720401]  [<ffffffffa04d421a>] uvc_dequeue_buffer+0x4a/0x70 [uvcvideo]
[ 2007.720401]  [<ffffffffa04d5e2c>] uvc_v4l2_do_ioctl+0xdfc/0x1320 [uvcvideo]
[ 2007.720401]  [<ffffffffa04a953c>] video_usercopy+0x17c/0x570 [videodev]
[ 2007.720401]  [<ffffffff81174375>] ? might_fault+0xa5/0xb0]
[ 2007.720401]  [<ffffffffa04d5030>] ? uvc_v4l2_open+0x140/0x140 [uvcvideo]
[ 2007.720401]  [<ffffffffa04d4779>] uvc_v4l2_ioctl+0x29/0x70 [uvcvideo]
[ 2007.720401]  [<ffffffffa04a8353>] v4l2_ioctl+0xc3/0x170 [videodev]
[ 2007.720401]  [<ffffffff811d0169>] do_vfs_ioctl+0x99/0x5a0
[ 2007.720401]  [<ffffffff811bd440>] ? fget_light+0xf0/0x4a0
[ 2007.720401]  [<ffffffff811bd3b2>] ? fget_light+0x62/0x4a0
[ 2007.720401]  [<ffffffff811d0709>] sys_ioctl+0x99/0xa0
[ 2007.720401]  [<ffffffff816a6d29>] system_call_fastpath+0x16/0x1b
[ 2007.720401] Code: 09 02 00 00 41 8b 84 24 10 07 00 00 31 d2 4d 8b 94 24 08 
07 00 00 41 8b b5 f0 02 00 00 89 c3 83 e8 01 f7 f1 48 c1 e3 05 4c 01 d3 <0f> 
b7 7b 04 44 8b 0b 89 d0 48 c1 e0 05 81 c7 00 08 00 00 49 01 
[ 2007.720401] RIP  [<ffffffffa04d83f2>] uvc_video_clock_update+0x72/0x3a0 
[uvcvideo]
[ 2007.720401]  RSP <ffff8800650c1ad8>
[ 2007.720401] CR2: 00000000000000a4
[ 2007.837048] hpet1: lost 5 rtc interrupts
[ 2007.855100] ---[ end trace 9a81e1b8ccffd693 ]---

...

[ 2007.855270] BUG: scheduling while atomic: plugin-containe/3337/0x10000002
[ 2007.855272] INFO: lockdep is turned off.
[ 2007.855274] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) 
vboxdrv(O) lockd sunrpc coretemp uvcvideo videobuf2_core videodev media 
v4l2_compat_ioctl32 videobuf2_vmalloc videobuf2_memops snd_usb_audio 
snd_usbmidi_lib snd_rawmidi snd_seq_device arc4 snd_hda_codec_conexant iwlwifi 
mac80211 snd_hda_intel i2c_i801 thinkpad_acpi cfg80211 snd_hda_codec snd_hwdep 
snd_pcm snd_timer snd_page_alloc rfkill microcode r592 memstick snd soundcore 
serial_cs e1000e iTCO_wdt iTCO_vendor_support binfmt_misc virtio_net kvm_intel 
kvm sdhci_pci sdhci mmc_core firewire_ohci firewire_core crc_itu_t 
yenta_socket wmi video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core 
[last unloaded: scsi_wait_scan]
[ 2007.855331] irq event stamp: 0
[ 2007.855333] hardirqs last  enabled at (0): [<          (null)>]           
(null)
[ 2007.855335] hardirqs last disabled at (0): [<ffffffff8105e7fe>] 
copy_process.part.21+0x56e/0x16f0
[ 2007.855339] softirqs last  enabled at (0): [<ffffffff8105e7fe>] 
copy_process.part.21+0x56e/0x16f0
[ 2007.855342] softirqs last disabled at (0): [<          (null)>]           
(null)
[ 2007.855346] Pid: 3337, comm: plugin-containe Tainted: G      D WC O 
3.3.0-0.rc3.git6.2.fc18.x86_64 #1
[ 2007.855348] Call Trace:
[ 2007.855351]  [<ffffffff810ca740>] ? print_irqtrace_events+0xd0/0xe0
[ 2007.855354]  [<ffffffff8169204e>] __schedule_bug+0x80/0x85
[ 2007.855357]  [<ffffffff8169c14b>] __schedule+0x8db/0x9a0
[ 2007.855361]  [<ffffffff8109bbaa>] __cond_resched+0x2a/0x40
[ 2007.855364]  [<ffffffff8169c290>] _cond_resched+0x30/0x40
[ 2007.855367]  [<ffffffff8169b56b>] down_read+0x2b/0x98
[ 2007.855370]  [<ffffffff8107a814>] exit_signals+0x24/0x130
[ 2007.855373]  [<ffffffff8106592c>] do_exit+0xdc/0xaa0
[ 2007.855376]  [<ffffffff81062aac>] ? kmsg_dump+0x9c/0x260
[ 2007.855379]  [<ffffffff81691973>] ? printk+0x51/0x53
[ 2007.855382]  [<ffffffff8169f40e>] oops_end+0x9e/0xe0
[ 2007.855385]  [<ffffffff81691276>] no_context+0x258/0x283
[ 2007.855388]  [<ffffffff8169146b>] __bad_area_nosemaphore+0x1ca/0x1e9
[ 2007.855391]  [<ffffffff8169149d>] bad_area_nosemaphore+0x13/0x15
[ 2007.855394]  [<ffffffff816a234b>] do_page_fault+0x4db/0x570
[ 2007.855397]  [<ffffffff811d10c7>] ? poll_freewait+0x47/0xb0
[ 2007.855400]  [<ffffffff811d1a4a>] ? do_select+0x77a/0x8a0
[ 2007.855403]  [<ffffffff8132b96d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 2007.855406]  [<ffffffff8169e775>] page_fault+0x25/0x30
[ 2007.855410]  [<ffffffffa04d83f2>] ? uvc_video_clock_update+0x72/0x3a0 
[uvcvideo]
[ 2007.855414]  [<ffffffffa04d83b1>] ? uvc_video_clock_update+0x31/0x3a0 
[uvcvideo]
[ 2007.855418]  [<ffffffffa04c9750>] ? vb2_dqbuf+0x220/0x3e0 [videobuf2_core]
[ 2007.855423]  [<ffffffffa04d3e26>] uvc_buffer_finish+0x26/0x30 [uvcvideo]
[ 2007.855426]  [<ffffffffa04c978f>] vb2_dqbuf+0x25f/0x3e0 [videobuf2_core]
[ 2007.855431]  [<ffffffffa04d4207>] ? uvc_dequeue_buffer+0x37/0x70 [uvcvideo]
[ 2007.855435]  [<ffffffffa04d421a>] uvc_dequeue_buffer+0x4a/0x70 [uvcvideo]
[ 2007.855439]  [<ffffffffa04d5e2c>] uvc_v4l2_do_ioctl+0xdfc/0x1320 [uvcvideo]
[ 2007.855444]  [<ffffffffa04a953c>] video_usercopy+0x17c/0x570 [videodev]
[ 2007.855447]  [<ffffffff81174375>] ? might_fault+0xa5/0xb0
[ 2007.855451]  [<ffffffffa04d5030>] ? uvc_v4l2_open+0x140/0x140 [uvcvideo]
[ 2007.855455]  [<ffffffffa04d4779>] uvc_v4l2_ioctl+0x29/0x70 [uvcvideo]
[ 2007.855460]  [<ffffffffa04a8353>] v4l2_ioctl+0xc3/0x170 [videodev]
[ 2007.855463]  [<ffffffff811d0169>] do_vfs_ioctl+0x99/0x5a0
[ 2007.855466]  [<ffffffff811bd440>] ? fget_light+0xf0/0x4a0
[ 2007.855469]  [<ffffffff811bd3b2>] ? fget_light+0x62/0x4a0
[ 2007.855472]  [<ffffffff811d0709>] sys_ioctl+0x99/0xa0
[ 2007.855475]  [<ffffffff816a6d29>] system_call_fastpath+0x16/0x1b
[ 2007.855488] note: plugin-containe[3337] exited with preempt_count 1

