Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2L1AZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:25:19 -0500
Received: from mta-1.ms.rz.rwth-aachen.de ([134.130.7.72]:48689 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab2L1AZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:25:16 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Dec 2012 19:25:16 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=utf-8
X-IronPort-AV: E=Sophos;i="4.84,365,1355094000";   d="scan'208";a="116896470"
Date: Thu, 27 Dec 2012 23:55:14 +0000
From: "David R. Piegdon" <lkml@p23q.org>
To: linux-kernel@vger.kernel.org
Cc: Zlatko Calusic <zlatko.calusic@iskon.hr>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 0000000000000500
Message-id: <20121227235514.GA7166@ganymede>
References: <692539675.35132464.1356520940797.JavaMail.root@redhat.com>
 <50DC622B.7000802@iskon.hr>
In-reply-to: <50DC622B.7000802@iskon.hr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

NOTE to everyone debugging this: reproduced quickly with X + firefox +
youtube (adobe flash plugin)

> Would you be so kind to test the following patch and report results?
> Apply the patch to the latest mainline.

I've had probably the same problem (dmesg below) and currently am trying
your patch applied to current mainline (101e5c7470eb7f). so far it looks
very good. (before: bug after 5-30 minutes, right now 1h and counting)

thanks!


[  105.164610] ------------[ cut here ]------------
[  105.164614] kernel BUG at mm/huge_memory.c:1798!
[  105.164617] invalid opcode: 0000 [#1] PREEMPT SMP 
[  105.164621] Modules linked in: fuse sha256_generic xt_owner xt_LOG xt_limit xt_recent xt_conntrack xt_multiport iptable_mangle xt_DSCP iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack fbcon font bitblit softcursor fb fbdev hwmon_vid btrfs zlib_deflate zlib_inflate xfs libcrc32c snd_usb_audio uvcvideo snd_usbmidi_lib videobuf2_core snd_rawmidi videobuf2_vmalloc videobuf2_memops hid_kensington iTCO_wdt joydev gpio_ich iTCO_vendor_support raid1 fglrx(PO) coretemp kvm_intel kvm skge acpi_cpufreq lpc_ich serio_raw asus_atk0110 snd_hda_codec_hdmi intel_agp snd_hda_intel mperf intel_gtt processor snd_hda_codec sky2 agpgart snd_hwdep [last unloaded: iTCO_wdt]
[  105.164672] CPU 1 
[  105.164677] Pid: 4091, comm: XPCOM CC Tainted: P           O 3.8.0-rc1+ #43 System manufacturer System Product Name/P5B-Deluxe
[  105.164679] RIP: 0010:[<ffffffff81120fb6>]  [<ffffffff81120fb6>] __split_huge_page+0x216/0x240
[  105.164688] RSP: 0018:ffff880091511c48  EFLAGS: 00010297
[  105.164690] RAX: 0000000000000001 RBX: ffff8800a210c000 RCX: 0000000000000042
[  105.164692] RDX: 00000000000000cb RSI: 0000000000000046 RDI: ffffffff81b28a20
[  105.164694] RBP: ffff880091511ca8 R08: 000000000000ffff R09: 0000000000000000
[  105.164696] R10: 000000000000043d R11: 0000000000000001 R12: ffff8800a2295c60
[  105.164698] R13: ffffea00021e0000 R14: 0000000000000000 R15: 00000007f5134600
[  105.164701] FS:  00007f514991e700(0000) GS:ffff8800bfc80000(0000) knlGS:0000000000000000
[  105.164703] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  105.164705] CR2: 00007f5123bff000 CR3: 000000009531b000 CR4: 00000000000007e0
[  105.164707] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  105.164709] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  105.164712] Process XPCOM CC (pid: 4091, threadinfo ffff880091510000, task ffff8800953616b0)
[  105.164713] Stack:
[  105.164715]  ffff880000000000 ffff8800b9c834b0 00007f5134800000 000000008158c4a5
[  105.164719]  ffff8800a210c064 00007f5134600000 ffff880091511ca8 ffffea00021e0000
[  105.164723]  ffff8800b9c83480 ffff8800a210c000 ffff88009fdc1d18 ffff8800a210c064
[  105.164727] Call Trace:
[  105.164732]  [<ffffffff81121048>] split_huge_page+0x68/0xb0
[  105.164736]  [<ffffffff81121d48>] __split_huge_page_pmd+0x1a8/0x220
[  105.164740]  [<ffffffff810f72f6>] unmap_page_range+0x1b6/0x2d0
[  105.164744]  [<ffffffff810f746b>] unmap_single_vma+0x5b/0xe0
[  105.164747]  [<ffffffff810f7e6c>] zap_page_range+0xbc/0x120
[  105.164752]  [<ffffffff8108f556>] ? futex_wake+0x116/0x130
[  105.164756]  [<ffffffff8106e396>] ? pick_next_task_fair+0x36/0xb0
[  105.164760]  [<ffffffff810f4367>] madvise_vma+0xf7/0x140
[  105.164764]  [<ffffffff810fddc2>] ? find_vma_prev+0x12/0x60
[  105.164767]  [<ffffffff810f45ed>] sys_madvise+0x23d/0x330
[  105.164772]  [<ffffffff8158e712>] system_call_fastpath+0x16/0x1b
[  105.164774] Code: 48 89 df e8 ed 10 ff ff e9 ab fe ff ff 0f 0b 41 8b 55 18 8b 75 bc ff c2 48 c7 c7 38 0e 7d 81 31 c0 e8 13 9b 46 00 e9 15 ff ff ff <0f> 0b 41 8b 4d 18 89 da ff c1 8b 75 bc 48 c7 c7 58 0e 7d 81 31 
[  105.164814] RIP  [<ffffffff81120fb6>] __split_huge_page+0x216/0x240
[  105.164818]  RSP <ffff880091511c48>
[  105.164823] ---[ end trace 00c060fd7d17a3d4 ]---

