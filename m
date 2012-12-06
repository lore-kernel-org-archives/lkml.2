Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2LFSKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:10:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2LFSKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:10:30 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_aGYK8jRc_AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SI-C17Dh1R0A:10 a=6SNqnIlpA5mXKCCq2UEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354817428.17101.10.camel@gandalf.local.home>
Subject: Re: [BUG] ftrace: available_filter_functions empty after unloading
 module
From: Steven Rostedt <rostedt@goodmis.org>
To: Piotr Haber <phaber@broadcom.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 06 Dec 2012 13:10:28 -0500
In-Reply-To: <50C0B236.4090200@broadcom.com>
References: <50C0B236.4090200@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 15:56 +0100, Piotr Haber wrote:
> Hi,
> not sure if this is a bug or just my misuse of ftrace.
> I get this warring after unloading a module that i traced before (used
> function tracer and 'brcmsmac*' as filter in set_ftrace_filter).
> After that reading available_filter_functions gives "No such device".
> 
> Regards
> Piotr
> 
> ------------[ cut here ]------------

We need to really remove that "cut here", because it causes people to
leave out other important information :-(  Or I could just add a print
that says...


*** Ignore the "cut here" below, and send the output after the end of
the cut as well *****


> WARNING: at kernel/trace/ftrace.c:1564
> __ftrace_hash_rec_update.part.34+0x20d/0x250()
> Hardware name: Latitude E6420
> Modules linked in: brcmsmac(O) brcmutil(O) bcma(O) mac80211(O)
> cfg80211(O) rfkill(O) arc4 cordic fuse ip6table_filter ip6_tables
> ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
> nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter
> ip_tables bridge stp llc snd_hda_codec_hdmi snd_hda_codec_idt coretemp
> kvm_intel snd_hda_intel kvm snd_hda_codec nouveau ttm drm_kms_helper drm
> ghash_clmulni_intel aesni_intel snd_hwdep snd_pcm_oss snd_mixer_oss
> snd_pcm ablk_helper snd_seq_dummy snd_seq_oss i2c_algo_bit i2c_core
> mxm_wmi cryptd lrw pl2303 usbserial snd_seq_midi aes_x86_64 snd_rawmidi
> xts snd_seq_midi_event gf128mul snd_seq video snd_timer ppdev
> dell_laptop dell_wmi serio_raw sparse_keymap dcdbas snd_seq_device snd
> microcode lpc_ich mfd_core parport_pc wmi soundcore snd_page_alloc lp
> parport ipv6 ext4 mbcache jbd2 sd_mod crc_t10dif sr_mod cdrom
> crc32c_intel ahci libahci sdhci_pci sdhci mmc_core e1000e [last
> unloaded: rfkill]
> Pid: 2498, comm: bash Tainted: G           O 3.7.0-rc8 #3
> Call Trace:
>  [<ffffffff810574ff>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff8105755a>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff810fdd7d>] __ftrace_hash_rec_update.part.34+0x20d/0x250
>  [<ffffffff810fea15>] ftrace_hash_move+0x1c5/0x1e0
>  [<ffffffff81100388>] ftrace_regex_release+0x98/0x150
>  [<ffffffff8118f7ac>] __fput+0xcc/0x290
>  [<ffffffff8118f97e>] ____fput+0xe/0x10
>  [<ffffffff810798e7>] task_work_run+0xa7/0xe0
>  [<ffffffff81015a64>] do_notify_resume+0x74/0x80
>  [<ffffffff81289eee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8157ed12>] int_signal+0x12/0x17
> ---[ end trace 476f7270ba7905df ]---

I know the issue but not the cause. The report should show more
information after this blurb that tells me what went wrong. Do you still
have access to the dump? Can you send me that, or if not, can you
reproduce it and give me you full dmesg?

Thanks!

-- Steve


