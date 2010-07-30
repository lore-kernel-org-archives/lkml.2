Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0G3DbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 23:31:22 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:38751 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755286Ab0G3DbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:31:21 -0400
Subject: 2.6.33.6-rt26: oops
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
        nando@ccrma.Stanford.EDU
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 20:30:42 -0700
Message-ID: <1280460642.2173.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Spam: Probability=8%, Report='
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, __CP_MEDIA_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...
This may not be rt related but here it goes anyway. It happened when I
tried to restart my iptables service (/sbin/service iptables start). I
think a day or two ago I had another network related hang, but it was a
complete hang (no clues left behind - power button to reset). 

-- Fernando



Jul 29 18:27:57 localhost kernel: BUG: unable to handle kernel NULL
pointer dereference at (null)
Jul 29 18:27:57 localhost kernel: IP: [<c045ad40>] exit_creds+0xc/0x54
Jul 29 18:27:57 localhost kernel: *pdpt = 0000000000a68001 *pde =
0000000000000000 
Jul 29 18:27:57 localhost kernel: Oops: 0000 [#1] PREEMPT SMP 
Jul 29 18:27:57 localhost kernel: last sysfs
file: /sys/devices/virtual/net/pan0/statistics/collisions
Jul 29 18:27:57 localhost kernel: Modules linked in: snd_seq_midi
snd_seq_midi_event snd_seq_dummy snd_usb_audio snd_usb_lib snd_rawmidi
fuse rfcomm sco bridge stp llc bnep l2cap sunrpc cpufreq_ondemand
acpi_cpufreq ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables
ipv6 dm_multipath uinput arc4 snd_hda_codec_analog ecb iwl3945
snd_hda_intel snd_hda_codec iwlcore thinkpad_acpi btusb sdhci_pci sdhci
mmc_core snd_hwdep e1000e snd_seq ohci1394 ricoh_mmc snd_seq_device
snd_pcm snd_timer snd mac80211 i2c_i801 iTCO_wdt iTCO_vendor_support
joydev cfg80211 bluetooth snd_page_alloc rfkill soundcore yenta_socket
rsrc_nonstatic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
output [last unloaded: microcode]
Jul 29 18:27:57 localhost kernel:
Jul 29 18:27:57 localhost kernel: Pid: 6956, comm: sirq-rcu/1 Not
tainted 2.6.33.6-147.2.4.rt26.1.fc12.ccrma.i686.rtPAE #1 6463CTO/6463CTO
Jul 29 18:27:57 localhost kernel: EIP: 0060:[<c045ad40>] EFLAGS:
00010287 CPU: 1
Jul 29 18:27:57 localhost kernel: EIP is at exit_creds+0xc/0x54
Jul 29 18:27:57 localhost kernel: EAX: 00000000 EBX: f0e1a430 ECX:
f0e1a960 EDX: 00000000
Jul 29 18:27:57 localhost kernel: ESI: c410434c EDI: f0e1a960 EBP:
f3321f38 ESP: f3321f34
Jul 29 18:27:57 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0
SS: 0068 preempt:00000000
Jul 29 18:27:57 localhost kernel: Process sirq-rcu/1 (pid: 6956,
ti=f3320000 task=f2b92d30 task.ti=f3320000)
Jul 29 18:27:57 localhost kernel: Stack:
Jul 29 18:27:57 localhost kernel: f0e1a430 f3321f44 c043e974 c4104334
f3321f4c c043e9b4 f3321f70 c048507b
Jul 29 18:27:57 localhost kernel: <0> 00000000 00000000 c099bbc0
00000283 c4103fdc c0a5cfec 00000200 f3321f78
Jul 29 18:27:57 localhost kernel: <0> c0485192 f3321fa4 c044445e
c0a5cfec f2b92d30 fffffdff 00000001 00000000
Jul 29 18:27:57 localhost kernel: Call Trace:
Jul 29 18:27:57 localhost kernel: [<c043e974>] ? __put_task_struct
+0x54/0x87
Jul 29 18:27:57 localhost kernel: [<c043e9b4>] ? __put_task_struct_cb
+0xd/0xf
Jul 29 18:27:57 localhost kernel: [<c048507b>] ? __rcu_process_callbacks
+0x153/0x21a
Jul 29 18:27:57 localhost kernel: [<c0485192>] ? rcu_process_callbacks
+0x50/0x57
Jul 29 18:27:57 localhost kernel: [<c044445e>] ? run_ksoftirqd
+0x138/0x236
Jul 29 18:27:57 localhost kernel: [<c0444326>] ? run_ksoftirqd+0x0/0x236
Jul 29 18:27:57 localhost kernel: [<c04557ae>] ? kthread+0x5f/0x64
Jul 29 18:27:57 localhost kernel: [<c045574f>] ? kthread+0x0/0x64
Jul 29 18:27:57 localhost kernel: [<c040907e>] ? kernel_thread_helper
+0x6/0x10
Jul 29 18:27:57 localhost kernel: Code: 00 00 00 89 f8 e8 cb d7 1d 00 89
f0 e8 bc fd ff ff 89 f0 e8 b5 fd ff ff 31 c0 5b 5e 5f 5d c3 55 89 e5 53
89 c3 8b 80 0c 03 00 00 <8b> 00 8b 83 08 03 00 00 c7 83 08 03 00 00 00
00 00 00 e8 8b fd 
Jul 29 18:27:57 localhost kernel: EIP: [<c045ad40>] exit_creds+0xc/0x54
SS:ESP 0068:f3321f34
Jul 29 18:27:57 localhost kernel: CR2: 0000000000000000
Jul 29 18:27:57 localhost kernel: ---[ end trace ebf66505b4c2cac5 ]---


