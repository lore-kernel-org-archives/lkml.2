Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1BHT6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:58:33 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:42696 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab1BHT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:58:31 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "R. Herbst" <ruediger.herbst@googlemail.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, Matt <jackdachef@gmail.com>,
        geert@linux-m68k.org
Subject: Re: Sun GEM PPC32 Bug?
References: <AANLkTin4ha5tkU_xgxkq7Kr6dG1-C2xR_04kBOrAngLH@mail.gmail.com>
	<1297056878.14982.65.camel@pasglop>
X-Yow: ..  So, if we convert SUPPLY-SIDE SOYBEAN FUTURES into
 HIGH-YIELD T-BILL INDICATORS, the PRE-INFLATIONARY risks
 will DWINDLE to a rate of 2 SHOPPING SPREES per EGGPLANT!!
Date: Tue, 08 Feb 2011 20:58:27 +0100
In-Reply-To: <1297056878.14982.65.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 07 Feb 2011 16:34:38 +1100")
Message-ID: <m2y65qe1ss.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> What's your machine model (cat /proc/cpuinfo) and what do you do to
> trigger the problem ? I'm trying to reproduce here and so far had
> no success doing so.

Just today I saw the same problem on my PowerMac G5, while sending a lot
of data over LAN.

NETDEV WATCHDOG: eth0 (gem): transmit queue 0 timed out
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:256
Modules linked in: usb_storage uas tcp_diag inet_diag firewire_sbp2 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device nfsd lockd exportfs auth_rpcgss nfs_acl sunrpc tun cpufreq_conservative cpufreq_userspace cpufreq_powersave nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6t_LOG ip6table_filter ip6_tables xt_TCPMSS xt_recent xt_state ipt_REJECT ipt_LOG xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables loop snd_aoa_codec_tas snd_aoa_fabric_layout snd_aoa snd_aoa_i2sbus snd_aoa_soundbus sg snd_pcm firewire_ohci snd_page_alloc firewire_core sr_mod snd_timer crc_itu_t uninorth_agp cdrom sungem sungem_phy snd agpgart soundcore linear sd_mod pata_macio dm_snapshot dm_mod sata_svw libata scsi_mod
NIP: c00000000030ae50 LR: c00000000030ae4c CTR: 0000000000000001
REGS: c00000000fff3a00 TRAP: 0700   Not tainted  (2.6.38-rc3)
MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 48ffff84  XER: 20000000
TASK = c00000017a0d28c0[0] 'swapper' THREAD: c00000017a0f0000 CPU: 1
GPR00: c00000000030ae4c c00000000fff3c80 c00000000085e410 000000000000003e 
GPR04: 0000000000000001 c00000000004d6f0 0000000000000000 0000000000000001 
GPR08: 0000000000000000 c00000017a0d28c0 c00000000006eb04 0000000000000001 
GPR12: 7472616e736d6974 c00000000ffff780 c0000001778d4400 0000000000000001 
GPR16: 0000000000000000 c0000001778d4000 c00000017a119c60 0000000000000100 
GPR20: c000000000869280 c00000017a119060 c00000017a119460 0000000000000001 
GPR24: ffffffffffffffff c00000017a5f0780 0000000000000002 0000000000000001 
GPR28: 0000000000000000 c0000001778d43a0 c0000000007f7350 c0000001778d4000 
NIP [c00000000030ae50] .dev_watchdog+0x19c/0x2cc
LR [c00000000030ae4c] .dev_watchdog+0x198/0x2cc
Call Trace:
[c00000000fff3c80] [c00000000030ae4c] .dev_watchdog+0x198/0x2cc (unreliable)
[c00000000fff3d80] [c00000000005986c] .run_timer_softirq+0x1c4/0x264
[c00000000fff3ec0] [c00000000005385c] .__do_softirq+0xe8/0x1c4
[c00000000fff3f90] [c000000000017628] .call_do_softirq+0x14/0x24
[c00000017a0f39b0] [c00000000000b2bc] .do_softirq+0x78/0xc4
[c00000017a0f3a50] [c0000000000539f8] .irq_exit+0x4c/0x9c
[c00000017a0f3ad0] [c000000000014704] .timer_interrupt+0xbc/0xd4
[c00000017a0f3b60] [c000000000003c8c] decrementer_common+0x10c/0x180
--- Exception: 901 at .cpu_idle+0x110/0x1d4
    LR = .cpu_idle+0x110/0x1d4
[c00000017a0f3e50] [c0000000000108fc] .cpu_idle+0x64/0x1d4 (unreliable)
[c00000017a0f3ee0] [c0000000003d22d0] .start_secondary+0x310/0x320
[c00000017a0f3f90] [c0000000000072dc] .start_secondary_prolog+0x10/0x14
Instruction dump:
41fe0040 38810070 7fe3fb78 38a00040 4bfea021 60000000 7fe4fb78 7f86e378 
7c651b78 e87e8030 480c35cd 60000000 <0fe00000> e93e8018 38000001 98090008 
---[ end trace cc84d3d8a2a0b1a7 ]---
gem 0001:03:0f.0: eth0: transmit timed out, resetting
gem 0001:03:0f.0: eth0: TX_STATE[003ffc05:00000001:0000001f]
gem 0001:03:0f.0: eth0: RX_STATE[0100c805:00000001:00000021]
gem 0001:03:0f.0: eth0: Link is up at 100 Mbps, full-duplex
gem 0001:03:0f.0: eth0: Pause is enabled (rxfifo: 10240 off: 7168 on: 5632)

The watchdog message happend only once, but the transmit timeouts
recurred over the whole transfer.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
