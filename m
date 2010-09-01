Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab0IAIVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:21:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab0IAIVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:21:19 -0400
Date: Wed, 1 Sep 2010 04:19:24 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.36-rc2-git5: Oops in snd_pcm_substream_proc_status_read()
Message-ID: <20100901041924.23a8a865@katamari>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 https://bugzilla.redhat.com/show_bug.cgi?id=628404

general protection fault: 0000 [#1] SMP 
last sysfs file:
/sys/devices/pci0000:00/0000:00:1b.0/sound/card0/pcmC0D0c/pcm_class
CPU 1 
Modules linked in: vfat fat fuse ebtable_nat ebtables ipt_MASQUERADE
iptable_nat nf_nat bridge stp llc sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ip6t_REJECT nf_conntrack_ipv6 xt_physdev ip6table_filter
ip6_tables kvm_intel kvm uinput snd_hda_codec_conexant usblp arc4 ecb
snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device iwlagn snd_pcm
iwlcore thinkpad_acpi snd_timer snd i2c_i801 mac80211 soundcore microcode
iTCO_wdt iTCO_vendor_support e1000e cfg80211 wmi snd_page_alloc rfkill ipv6
usb_storage i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last
unloaded: scsi_wait_scan]

Pid: 16071, comm: pulseaudio Not tainted 2.6.36-0.11.rc2.git5.fc15.x86_64 #1
74585FU/74585FU
RIP: 0010:[<ffffffffa0296742>]  [<ffffffffa0296742>]
snd_pcm_substream_proc_status_read+0x164/0x1ad [snd_pcm]
RSP: 0018:ffff8801178c1b58  EFLAGS: 00010292
RAX: 6b6b6b6b6b6b6b6b RBX: ffff88003d993bc8 RCX: 0000000000000000
RDX: ffffffffa02a1996 RSI: ffffffffa02a1997 RDI: ffff88003d993bc8
RBP: ffff8801178c1c18 R08: 0000000000000006 R09: 00000000fffffff7
R10: ffff8800044ea048 R11: 0000000000000000 R12: ffff8801332d31b0
R13: ffff88013438d488 R14: ffff88013438e050 R15: ffff880111131880
FS:  00007fbccba77780(0000) GS:ffff880002e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fbf324db008 CR3: 00000001157be000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pulseaudio (pid: 16071, threadinfo ffff8801178c0000, task
ffff880130f88000)
Stack:
 0000000000000003 0000000000005e84 000000002ee6c142 0000000000005e85
<0> 000000001624774a 0000000000000000 00000000000064b0 00000000000064b0
<0> 00000000000064b0 00000000000064b0 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa020ac22>] snd_info_entry_open+0x307/0x389 [snd]
 [<ffffffff81179034>] proc_reg_open+0xfa/0x17a
 [<ffffffffa020a91b>] ? snd_info_entry_open+0x0/0x389 [snd]
 [<ffffffffa0209fa7>] ? snd_info_entry_release+0x0/0xd8 [snd]
 [<ffffffff81178f3a>] ? proc_reg_open+0x0/0x17a
 [<ffffffff81128f1f>] __dentry_open+0x1c2/0x338
 [<ffffffff81129da0>] nameidata_to_filp+0x3f/0x50
 [<ffffffff81136200>] do_last+0x432/0x5af
 [<ffffffff81246a75>] ? __raw_spin_lock_init+0x31/0x50
 [<ffffffff811365ad>] do_filp_open+0x230/0x5e1
 [<ffffffff810fac10>] ? might_fault+0x5c/0xac
 [<ffffffff8114040b>] ? alloc_fd+0x3b/0x17c
 [<ffffffff8107fc2a>] ? lock_release+0x19a/0x1a6
 [<ffffffff8114053a>] ? alloc_fd+0x16a/0x17c
 [<ffffffff81129e11>] do_sys_open+0x60/0xfc
 [<ffffffff8149aca2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81129ecd>] sys_open+0x20/0x22
 [<ffffffff81009cb2>] system_call_fastpath+0x16/0x1b
Code: df 31 c0 e8 e6 40 f7 ff 48 c7 c6 90 19 2a a0 48 89 df 31 c0 e8 d5 40 f7
ff 49 8b 84 24 f0 00 00 00 48 c7 c6 97 19 2a a0 48 89 df <48> 8b 50 08 31 c0 e8
b8 40 f7 ff 49 8b 84 24 f8 00 00 00 48 c7 
RIP  [<ffffffffa0296742>] snd_pcm_substream_proc_status_read+0x164/0x1ad
[snd_pcm]
 RSP <ffff8801178c1b58>
---[ end trace 96389f116dd90473 ]---

Faulting insn:
48 8b 50 08           mov    0x8(%rax),%rdx

RAX: 6b6b6b6b6b6b6b6b

sound/core/pcm.c:453:

   snd_iprintf(buffer, "hw_ptr : %ld\n", runtime->status->hw_ptr);

runtime = 0x6b6b6b6b6b6b6b6b

The code checks for NULL before using it, but this is a poison value.
