Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0ITFa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 01:30:28 -0400
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79]:34131 "HELO
	smtp101.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750934Ab0ITFa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 01:30:26 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 01:30:26 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=j8iy+vKYV1J4A6ByQEMt+u1SkssDs1ZdUiBctn1E4fL2/X5vqAxyFniEAWL2UhibY4U3TNAZWPJQe13umN93bnFQ+HQPs1pPquxEnrENA/82pHf1a0H9I4LoOHFSmPaNZD2FtkpaiBiNywoQ3Scx8npVBWZILPaouvGr39bg594=  ;
Message-ID: <650240.84760.qm@smtp101.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 9rDUxoQVM1nB_K8.7z70jNPCbuqyDqE6WxNRexKqO.kH9LH
 AYS6rv6L6
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [i915] 2.6.36-rc4-git2 (Fedora snapshot) - kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1444!
Date: Mon, 20 Sep 2010 01:23:41 -0400
User-Agent: KMail/4.5 beta1 (Linux/2.6.36-0.22.rc4.git2.fc15.x86_64; KDE/4.5.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've been hitting this repeatedly in using this kernel this is a recent issue. Also, www.kerneloops.org seems broken, someone might want to fix this? We can disregard virtualbox drivers causing this especially given the 
traceback.

trace below:

------------[ cut here ]------------
kernel BUG at drivers/gpu/drm/i915/i915_gem.c:1444!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
CPU 0
Modules linked in: tcp_lp cryptd aes_x86_64 aes_generic vboxnetadp vboxnetflt vboxdrv sco bnep l2cap bluetooth sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf uinput snd_hda_codec_conexant snd_hda_intel snd_hda_codec arc4 
ecb snd_usb_audio uvcvideo iwlagn snd_hwdep snd_usbmidi_lib snd_seq videodev v4l1_compat iwlcore mac80211 snd_pcm snd_rawmidi v4l2_compat_ioctl32 r852 sm_common nand nand_ids nand_ecc mtd thinkpad_acpi snd_timer snd_seq_device 
i2c_i801 iTCO_wdt e1000e snd snd_page_alloc cfg80211 soundcore rfkill iTCO_vendor_support joydev microcode wmi firewire_ohci sdhci_pci sdhci firewire_core mmc_core crc_itu_t yenta_socket i915 drm_kms_helper drm usb_storage 
i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]

Pid: 1507, comm: X Not tainted 2.6.36-0.22.rc4.git2.fc15.x86_64 #1 4058CTO/4058CTO
RIP: 0010:[<ffffffffa0093026>]  [<ffffffffa0093026>] i915_gem_object_put_pages+0x25/0xf5 [i915]
RSP: 0018:ffff880138671ad8  EFLAGS: 00010246
RAX: 0000000000000002 RBX: ffff880019504e00 RCX: ffff88002cc6fd40
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff880019504e00
RBP: ffff880138671af8 R08: ffffffff82892420 R09: ffff880138671888
R10: ffffffff82892438 R11: ffff8800325f3a50 R12: 0000000000000000
R13: ffff880135f55000 R14: 0000000000000001 R15: ffff880136be54e0
FS:  00007f3621a878a0(0000) GS:ffff880002c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa44c7c4ffc CR3: 00000001378a7000 CR4: 00000000000426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 1507, threadinfo ffff880138670000, task ffff880137d8c800)
Stack:
 ffff880019504e00 0000000000000000 ffff880135f55000 ffff880136be4000
<0> ffff880138671b28 ffffffffa009481d ffff88005a9d4600 ffff880138671b78
<0> 0000000003000000 0000000000001000 ffff880138671bb8 ffffffffa0098ab2
Call Trace:
 [<ffffffffa009481d>] i915_gem_object_unbind+0xc5/0x1a7 [i915]
 [<ffffffffa0098ab2>] i915_gem_evict_something+0x3bd/0x409 [i915]
 [<ffffffffa0027923>] ? drm_gem_object_lookup+0x27/0x57 [drm]
 [<ffffffffa0093bc3>] i915_gem_object_bind_to_gtt+0x1d3/0x279 [i915]
 [<ffffffffa0095b30>] i915_gem_object_pin+0xa3/0x146 [i915]
 [<ffffffffa0027948>] ? drm_gem_object_lookup+0x4c/0x57 [drm]
 [<ffffffffa00961bc>] i915_gem_do_execbuffer+0x50d/0xe32 [i915]
 [<ffffffff8107fdd3>] ? lock_acquire+0xee/0xfd
 [<ffffffff810fad05>] ? might_fault+0xa5/0xac
 [<ffffffff810facbc>] ? might_fault+0x5c/0xac
 [<ffffffffa0092c97>] ? drm_malloc_ab+0x3b/0x53 [i915]
 [<ffffffffa0096baf>] i915_gem_execbuffer2+0xce/0x12d [i915]
 [<ffffffff810fad05>] ? might_fault+0xa5/0xac
 [<ffffffffa0026256>] drm_ioctl+0x2ae/0x390 [drm]
 [<ffffffffa0096ae1>] ? i915_gem_execbuffer2+0x0/0x12d [i915]
 [<ffffffff81138de1>] do_vfs_ioctl+0x4c4/0x505
 [<ffffffff8112b74f>] ? fcheck_files+0x7b/0xe0
 [<ffffffff81138e78>] sys_ioctl+0x56/0x7a
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
Code: 44 9b 06 e1 c9 c3 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 00 00 4c 8b 77 60 8a 87 c1 00 00 00 48 89 fb 49 c1 ee 0c a8 0c 75 02 <0f> 0b 88 c2 83 e2 03 80 fa 02 75 02 0f 0b 88 c2 83 e0 f3 c0 ea
RIP  [<ffffffffa0093026>] i915_gem_object_put_pages+0x25/0xf5 [i915]
 RSP <ffff880138671ad8>

