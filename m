Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0LJM6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:58:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:10727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab0LJM6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:58:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,323,1288594800"; 
   d="scan'208";a="685841446"
Subject: Re: BUG at perf_ctx_adjust_freq (kernel/perf_event.c:1582)
From: Lin Ming <ming.m.lin@intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <AANLkTi=ZjBKkxJDDSCNzsZ_oma485xKafMEXWet8EOXd@mail.gmail.com>
References: <c6d829$pqibha@fmsmga001.fm.intel.com>
	 <AANLkTi=ZjBKkxJDDSCNzsZ_oma485xKafMEXWet8EOXd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 20:58:43 +0800
Message-Id: <1291985923.2538.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>
> Strange OOPS, not sure what triggered it, but in case it helps:

Hi,

Can you reproduce it?

Lin Ming

> 
> [57260.405026] BUG: unable to handle kernel paging request at 01000000
> [57260.405098] IP: [<c04a1d3d>] perf_ctx_adjust_freq+0x110/0x132
> [57260.405153] *pde = 00000000
> [57260.405181] Oops: 0000 [#1] SMP
> [57260.405216] last sysfs file: /sys/module/cpufreq_ondemand/refcnt
> [57260.405265] Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss
> sunrpc sco bnep l2cap bluetooth fuse acpi_cpufreq mperf
> snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> snd_seq_device arc4 ecb snd_pcm thinkpad_acpi snd_timer snd iwlagn iwlcore
> mac80211 r852 sm_common nand nand_ids nand_ecc uvcvideo mtd iTCO_wdt
> joydev videodev i2c_i801 cfg80211 v4l1_compat ppdev iTCO_vendor_support
> soundcore rfkill wmi pcspkr microcode parport_pc parport snd_page_alloc
> uinput ipv6 sdhci_pci sdhci mmc_core firewire_ohci firewire_core
> yenta_socket crc_itu_t i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> output [last unloaded: cpufreq_ondemand]
> [57260.405938]
> [57260.405955] Pid: 31699, comm: gdb Not tainted 2.6.37-rc4+ #3 7661BL5/7661BL5
> [57260.406006] EIP: 0060:[<c04a1d3d>] EFLAGS: 00210012 CPU: 1
> [57260.406006] EIP is at perf_ctx_adjust_freq+0x110/0x132
> [57260.406006] EAX: 01000000 EBX: 000f41a8 ECX: 00000000 EDX: f1e441b0
> [57260.406006] ESI: 00000000 EDI: 00fffff8 EBP: f3637ed0 ESP: f3637ea8
> [57260.406006]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [57260.406006] Process gdb (pid: 31699, ti=f3636000 task=f1c94b60
> task.ti=f3636000)
> [57260.406006] Stack:
> [57260.406006]  00000000 f3723e00 f1e441b0 c042af08 00000000 f1e44180
> 01000000 00000000
> [57260.406006]  f4e06be4 f1e44180 f3637efc c04a1e3e 000f41a8 00000000
> 00000001 f4e06c74
> [57260.406006]  f4e06f10 f4e036e0 c07cdc34 f4e06300 00000001 f3637f14
> c0435875 f1c94b60
> [57260.406006] Call Trace:
> [57260.406006]  [<c042af08>] ? update_curr+0xab/0x124
> [57260.406006]  [<c04a1e3e>] ? perf_event_task_tick+0xdf/0x1ab
> [57260.406006]  [<c0435875>] ? scheduler_tick+0xb0/0x1f0
> [57260.406006]  [<c0444889>] ? update_process_times+0x51/0x5d
> [57260.406006]  [<c045bcef>] ? tick_sched_timer+0x72/0xa0
> [57260.406006]  [<c045287f>] ? __run_hrtimer+0xa1/0x116
> [57260.406006]  [<c045bc7d>] ? tick_sched_timer+0x0/0xa0
> [57260.406006]  [<c04531b2>] ? hrtimer_interrupt+0xde/0x1b3
> [57260.406006]  [<c041aa59>] ? smp_apic_timer_interrupt+0x60/0x73
> [57260.406006]  [<c07c0109>] ? apic_timer_interrupt+0x31/0x38
> [57260.406006] Code: 00 00 7c 1b 7f 06 83 7d d8 00 76 13 ff 75 dc 89 da ff
> 75 d8 89 f8 89 f1 e8 5a cc ff ff 58 5a 8b 47 08 89 45 f0 8b 7d f0 83 ef 08
> <8b> 47 08 e8 e1 bf ff ff 8d 47 08 3b 45 e0 0f 85 0e ff ff ff 8b
> [57260.406006] EIP: [<c04a1d3d>] perf_ctx_adjust_freq+0x110/0x132
> SS:ESP 0068:f3637ea8
> [57260.406006] CR2: 0000000001000000
> [57260.406006] ---[ end trace 8b112fc89b85bbd4 ]---
> 
> --
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


