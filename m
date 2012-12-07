Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2LGIHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:07:13 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2759 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab2LGIHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:07:11 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <50C1A3A3.8030107@broadcom.com>
Date: Fri, 7 Dec 2012 09:06:59 +0100
From: "Piotr Haber" <phaber@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Steven Rostedt" <rostedt@goodmis.org>
cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ftrace: available_filter_functions empty after
 unloading module
References: <50C0B236.4090200@broadcom.com>
 <1354817428.17101.10.camel@gandalf.local.home>
In-Reply-To: <1354817428.17101.10.camel@gandalf.local.home>
X-Enigmail-Version: 1.1.1
X-WSS-ID: 7CDF7CB91QK16741338-01-01
Content-Type: text/plain;
 charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/12 19:10, Steven Rostedt wrote:
> On Thu, 2012-12-06 at 15:56 +0100, Piotr Haber wrote:
>> Hi,
>> not sure if this is a bug or just my misuse of ftrace.
>> I get this warring after unloading a module that i traced before (used
>> function tracer and 'brcmsmac*' as filter in set_ftrace_filter).
>> After that reading available_filter_functions gives "No such device".
>>
>> Regards
>> Piotr
>>
>> ------------[ cut here ]------------
> 
> We need to really remove that "cut here", because it causes people to
> leave out other important information :-(  Or I could just add a print
> that says...
> 
> 
> *** Ignore the "cut here" below, and send the output after the end of
> the cut as well *****
> 
> 
>> WARNING: at kernel/trace/ftrace.c:1564
>> __ftrace_hash_rec_update.part.34+0x20d/0x250()
>> Hardware name: Latitude E6420
>> Modules linked in: brcmsmac(O) brcmutil(O) bcma(O) mac80211(O)
>> cfg80211(O) rfkill(O) arc4 cordic fuse ip6table_filter ip6_tables
>> ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
>> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter
>> ip_tables bridge stp llc snd_hda_codec_hdmi snd_hda_codec_idt coretemp
>> kvm_intel snd_hda_intel kvm snd_hda_codec nouveau ttm drm_kms_helper drm
>> ghash_clmulni_intel aesni_intel snd_hwdep snd_pcm_oss snd_mixer_oss
>> snd_pcm ablk_helper snd_seq_dummy snd_seq_oss i2c_algo_bit i2c_core
>> mxm_wmi cryptd lrw pl2303 usbserial snd_seq_midi aes_x86_64 snd_rawmidi
>> xts snd_seq_midi_event gf128mul snd_seq video snd_timer ppdev
>> dell_laptop dell_wmi serio_raw sparse_keymap dcdbas snd_seq_device snd
>> microcode lpc_ich mfd_core parport_pc wmi soundcore snd_page_alloc lp
>> parport ipv6 ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom
>> crc32c_intel ahci libahci sdhci_pci sdhci mmc_core e1000e [last
>> unloaded: rfkill]
>> Pid: 2498, comm: bash Tainted: G           O 3.7.0-rc8 #3
>> Call Trace:
>>  [<ffffffff810574ff>] warn_slowpath_common+0x7f/0xc0
>>  [<ffffffff8105755a>] warn_slowpath_null+0x1a/0x20
>>  [<ffffffff810fdd7d>] __ftrace_hash_rec_update.part.34+0x20d/0x250
>>  [<ffffffff810fea15>] ftrace_hash_move+0x1c5/0x1e0
>>  [<ffffffff81100388>] ftrace_regex_release+0x98/0x150
>>  [<ffffffff8118f7ac>] __fput+0xcc/0x290
>>  [<ffffffff8118f97e>] ____fput+0xe/0x10
>>  [<ffffffff810798e7>] task_work_run+0xa7/0xe0
>>  [<ffffffff81015a64>] do_notify_resume+0x74/0x80
>>  [<ffffffff81289eee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>>  [<ffffffff8157ed12>] int_signal+0x12/0x17
>> ---[ end trace 476f7270ba7905df ]---
> 
> I know the issue but not the cause. The report should show more
> information after this blurb that tells me what went wrong. Do you still
> have access to the dump? Can you send me that, or if not, can you
> reproduce it and give me you full dmesg?
> 
> Thanks!
> 
> -- Steve
Hi,
sorry to disappoint you, but there is really nothing more around the
warning.
I know it is not helpful, maybe i can do some more tracing if you tell
me how

Here it is with broader context:

Dec  6 15:22:27 lb-bun-52 kernel: cfg80211: Calling CRDA to update world
regulatory domain
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211: World regulatory domain updated:
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (start_freq - end_freq @
bandwidth), (max_antenna_gain, max_eirp)
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (2402000 KHz - 2472000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (2457000 KHz - 2482000 KHz
@ 20000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (2474000 KHz - 2494000 KHz
@ 20000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (5170000 KHz - 5250000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:22:27 lb-bun-52 kernel: cfg80211:   (5735000 KHz - 5835000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus0: Found chip with id 0xA8D8,
rev 0x01 and package 0x0A
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus0: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus0: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus0: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x0F, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus0: Bus registered
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus1: Found chip with id 0x4313,
rev 0x01 and package 0x08
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus1: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus1: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus1: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x11, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus1: Bus registered
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus2: Found chip with id 0x4313,
rev 0x01 and package 0x08
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus2: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus2: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus2: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x11, class 0x0)
Dec  6 15:22:27 lb-bun-52 kernel: bcma: bus2: Bus registered
Dec  6 15:22:27 lb-bun-52 kernel: brcmsmac bcma0:0: mfg 4bf core 812 rev
23 class 0 irq 16
Dec  6 15:22:27 lb-bun-52 kernel: ieee80211 phy0: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:22:27 lb-bun-52 kernel: Registered led device: brcmsmac-phy0:radio
Dec  6 15:22:27 lb-bun-52 kernel: brcmsmac bcma1:0: mfg 4bf core 812 rev
24 class 0 irq 17
Dec  6 15:22:27 lb-bun-52 kernel: ieee80211 phy1: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:22:27 lb-bun-52 kernel: Registered led device: brcmsmac-phy1:radio
Dec  6 15:22:27 lb-bun-52 kernel: brcmsmac bcma2:0: mfg 4bf core 812 rev
24 class 0 irq 16
Dec  6 15:22:27 lb-bun-52 kernel: ieee80211 phy2: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:22:27 lb-bun-52 kernel: Registered led device: brcmsmac-phy2:radio
Dec  6 15:22:34 lb-bun-52 kernel: ------------[ cut here ]------------
Dec  6 15:22:34 lb-bun-52 kernel: WARNING: at kernel/trace/ftrace.c:1564
__ftrace_hash_rec_update.part.34+0x20d/0x250()
Dec  6 15:22:34 lb-bun-52 kernel: Hardware name: Latitude E6420
Dec  6 15:22:34 lb-bun-52 kernel: Modules linked in: brcmsmac(O)
brcmutil(O) bcma(O) mac80211(O) cfg80211(O) rfkill(O) arc4 cordic fuse
ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_i
pv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM
iptable_mangle iptable_filter ip_tables bridge stp llc
snd_hda_codec_hdmi snd_hda_codec_idt coretemp kvm_intel snd_hda_intel
kvm snd_h
da_codec nouveau ttm drm_kms_helper drm ghash_clmulni_intel aesni_intel
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm ablk_helper snd_seq_dummy
snd_seq_oss i2c_algo_bit i2c_core mxm_wmi cryptd lrw pl2
303 usbserial snd_seq_midi aes_x86_64 snd_rawmidi xts snd_seq_midi_event
gf128mul snd_seq video snd_timer ppdev dell_laptop dell_wmi serio_raw
sparse_keymap dcdbas snd_seq_device snd microcode lpc_i
ch mfd_core parport_pc wmi soundcore snd_page_alloc lp parport ipv6 ext4
mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom crc32c_intel ahci libahci
sdhci_pci sdhci mmc_core e1000e [last unloaded: rfkill]
Dec  6 15:22:34 lb-bun-52 kernel: Pid: 2498, comm: bash Tainted: G
     O 3.7.0-rc8 #3
Dec  6 15:22:34 lb-bun-52 kernel: Call Trace:
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff810574ff>]
warn_slowpath_common+0x7f/0xc0
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff8105755a>]
warn_slowpath_null+0x1a/0x20
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff810fdd7d>]
__ftrace_hash_rec_update.part.34+0x20d/0x250
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff810fea15>]
ftrace_hash_move+0x1c5/0x1e0
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff81100388>]
ftrace_regex_release+0x98/0x150
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff8118f7ac>] __fput+0xcc/0x290
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff8118f97e>] ____fput+0xe/0x10
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff810798e7>]
task_work_run+0xa7/0xe0
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff81015a64>]
do_notify_resume+0x74/0x80
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff81289eee>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Dec  6 15:22:34 lb-bun-52 kernel: [<ffffffff8157ed12>] int_signal+0x12/0x17
Dec  6 15:22:34 lb-bun-52 kernel: ---[ end trace 476f7270ba7905df ]---
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211: Calling CRDA to update world
regulatory domain
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211: World regulatory domain updated:
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (start_freq - end_freq @
bandwidth), (max_antenna_gain, max_eirp)
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (2402000 KHz - 2472000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (2457000 KHz - 2482000 KHz
@ 20000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (2474000 KHz - 2494000 KHz
@ 20000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (5170000 KHz - 5250000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:35:41 lb-bun-52 kernel: cfg80211:   (5735000 KHz - 5835000 KHz
@ 40000 KHz), (300 mBi, 2000 mBm)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus0: Found chip with id 0xA8D8,
rev 0x01 and package 0x0A
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus0: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus0: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus0: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x0F, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus0: Bus registered
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus1: Found chip with id 0x4313,
rev 0x01 and package 0x08
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus1: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus1: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus1: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x11, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus1: Bus registered
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus2: Found chip with id 0x4313,
rev 0x01 and package 0x08
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus2: Core 0 found: ChipCommon
(manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus2: Core 1 found: IEEE 802.11
(manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus2: Core 2 found: PCIe (manuf
0x4BF, id 0x820, rev 0x11, class 0x0)
Dec  6 15:35:41 lb-bun-52 kernel: bcma: bus2: Bus registered
Dec  6 15:35:41 lb-bun-52 kernel: brcmsmac bcma0:0: mfg 4bf core 812 rev
23 class 0 irq 16
Dec  6 15:35:41 lb-bun-52 kernel: ieee80211 phy0: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:35:41 lb-bun-52 kernel: brcmsmac bcma1:0: mfg 4bf core 812 rev
24 class 0 irq 17
Dec  6 15:35:41 lb-bun-52 kernel: ieee80211 phy1: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:35:41 lb-bun-52 kernel: brcmsmac bcma2:0: mfg 4bf core 812 rev
24 class 0 irq 16
Dec  6 15:35:41 lb-bun-52 kernel: ieee80211 phy2: Selected rate control
algorithm 'minstrel_ht'
Dec  6 15:57:55 lb-bun-52 kernel: Kernel logging (proc) stopped.


