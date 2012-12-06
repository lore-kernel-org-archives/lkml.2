Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423646Ab2LFO5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:57:07 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:4171 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423612Ab2LFO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:57:05 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50C0B236.4090200@broadcom.com>
Date: Thu, 6 Dec 2012 15:56:54 +0100
From: "Piotr Haber" <phaber@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [BUG] ftrace: available_filter_functions empty after unloading
 module
X-Enigmail-Version: 1.1.1
X-WSS-ID: 7CDE6E1B3R015706424-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
not sure if this is a bug or just my misuse of ftrace.
I get this warring after unloading a module that i traced before (used
function tracer and 'brcmsmac*' as filter in set_ftrace_filter).
After that reading available_filter_functions gives "No such device".

Regards
Piotr

------------[ cut here ]------------
WARNING: at kernel/trace/ftrace.c:1564
__ftrace_hash_rec_update.part.34+0x20d/0x250()
Hardware name: Latitude E6420
Modules linked in: brcmsmac(O) brcmutil(O) bcma(O) mac80211(O)
cfg80211(O) rfkill(O) arc4 cordic fuse ip6table_filter ip6_tables
ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter
ip_tables bridge stp llc snd_hda_codec_hdmi snd_hda_codec_idt coretemp
kvm_intel snd_hda_intel kvm snd_hda_codec nouveau ttm drm_kms_helper drm
ghash_clmulni_intel aesni_intel snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm ablk_helper snd_seq_dummy snd_seq_oss i2c_algo_bit i2c_core
mxm_wmi cryptd lrw pl2303 usbserial snd_seq_midi aes_x86_64 snd_rawmidi
xts snd_seq_midi_event gf128mul snd_seq video snd_timer ppdev
dell_laptop dell_wmi serio_raw sparse_keymap dcdbas snd_seq_device snd
microcode lpc_ich mfd_core parport_pc wmi soundcore snd_page_alloc lp
parport ipv6 ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom
crc32c_intel ahci libahci sdhci_pci sdhci mmc_core e1000e [last
unloaded: rfkill]
Pid: 2498, comm: bash Tainted: G           O 3.7.0-rc8 #3
Call Trace:
 [<ffffffff810574ff>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8105755a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810fdd7d>] __ftrace_hash_rec_update.part.34+0x20d/0x250
 [<ffffffff810fea15>] ftrace_hash_move+0x1c5/0x1e0
 [<ffffffff81100388>] ftrace_regex_release+0x98/0x150
 [<ffffffff8118f7ac>] __fput+0xcc/0x290
 [<ffffffff8118f97e>] ____fput+0xe/0x10
 [<ffffffff810798e7>] task_work_run+0xa7/0xe0
 [<ffffffff81015a64>] do_notify_resume+0x74/0x80
 [<ffffffff81289eee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8157ed12>] int_signal+0x12/0x17
---[ end trace 476f7270ba7905df ]---

