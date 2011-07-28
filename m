Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1G1Sm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:42:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1G1Sm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:42:56 -0400
Subject: Re: [perf] overflow/perf_count_sw_cpu_clock crashes recent kernels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        stable <stable@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 20:47:10 +0200
Message-ID: <1311878830.2617.373.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 14:51 -0400, Vince Weaver wrote:
> [  392.504845] ------------[ cut here ]------------
> [  392.504962] WARNING: at kernel/smp.c:320 smp_call_function_single+0x6c/0xf2()
> [  392.505074] Hardware name: Precision M4500
> [  392.505181] Modules linked in: acpi_cpufreq cpufreq_conservative mperf cpufreq_powersave cpufreq_userspace cpufreq_stats uinput nouveau snd_hda_codec_hdmi ttm drm_kms_helper mxm_wmi snd_hda_codec_idt iwlagn mac80211 snd_hda_intel snd_hda_codec cfg80211 dell_laptop snd_hwdep video processor ehci_hcd dell_wmi sparse_keymap psmouse sdhci_pci rfkill snd_pcm sdhci thermal_sys pcspkr ac battery wmi serio_raw snd_timer snd_page_alloc evdev i2c_i801 dcdbas button
> [  392.509709] Pid: 2310, comm: overflow_allcou Not tainted 3.0.0 #43
> [  392.509819] Call Trace:
> [  392.509925]  <IRQ>  [<ffffffff81041bb0>] ? warn_slowpath_common+0x78/0x8c
> [  392.510144]  [<ffffffff810a4d19>] ? perf_exclude_event.part.23+0x31/0x31
> [  392.510257]  [<ffffffff8106b7c5>] ? smp_call_function_single+0x6c/0xf2
> [  392.510369]  [<ffffffff810a38aa>] ? task_function_call+0x42/0x4c
> [  392.510476]  [<ffffffff810a50e4>] ? update_cgrp_time_from_event+0x2c/0x2c
> [  392.510589]  [<ffffffff810a5a9d>] ? perf_event_disable+0x45/0x8c
> [  392.510700]  [<ffffffff810a8e89>] ? __perf_event_overflow+0xf1/0x1a3
> [  392.510812]  [<ffffffff8103c7bb>] ? select_task_rq_fair+0x349/0x574
> [  392.510924]  [<ffffffff810a7f0a>] ? perf_ctx_adjust_freq+0x42/0xe6
> [  392.511038]  [<ffffffff8105f152>] ? sched_clock_cpu+0xb/0xc3
> [  392.511152]  [<ffffffff8100ded5>] ? paravirt_read_tsc+0x5/0x8
> [  392.511262]  [<ffffffff8100e320>] ? native_sched_clock+0x27/0x2f
> [  392.511366]  [<ffffffff810a9500>] ? perf_event_overflow+0x10/0x10
> [  392.511476]  [<ffffffff810a959f>] ? perf_swevent_hrtimer+0x9f/0xda
> [  392.511599]  [<ffffffff8105ca04>] ? run_posix_cpu_timers+0x23/0x346
> [  392.511721]  [<ffffffff8131c2ef>] ? rb_insert_color+0xb1/0xd9
> [  392.511841]  [<ffffffff8105d373>] ? __run_hrtimer+0xac/0x135
> [  392.511960]  [<ffffffff8105daa3>] ? hrtimer_interrupt+0xdb/0x195
> [  392.512083]  [<ffffffff8108d040>] ? check_for_new_grace_period.isra.32+0x99/0xa4
> [  392.512220]  [<ffffffff8108d201>] ? __rcu_process_callbacks+0x72/0x2b7
> [  392.512345]  [<ffffffff8102437c>] ? hpet_interrupt_handler+0x23/0x2b
> [  392.512469]  [<ffffffff81089446>] ? handle_irq_event_percpu+0x50/0x180
> [  392.512592]  [<ffffffff81046f76>] ? __do_softirq+0x13e/0x177
> [  392.512713]  [<ffffffff810f680c>] ? send_sigio+0x95/0xab
> [  392.512832]  [<ffffffff810895aa>] ? handle_irq_event+0x34/0x52
> [  392.512952]  [<ffffffff8108b433>] ? handle_edge_irq+0x9f/0xc6
> [  392.513072]  [<ffffffff8100a831>] ? handle_irq+0x1d/0x21
> [  392.513192]  [<ffffffff8100a561>] ? do_IRQ+0x42/0x98
> [  392.513314]  [<ffffffff81593053>] ? common_interrupt+0x13/0x13
> [  392.513438]  <EOI> 
> [  392.513542] ---[ end trace 12f3f913316a2866 ]--- 

The below patch is for -stable only, upstream has a much larger patch
that contains the below hunk.

---
Subject: perf: Fix software event overflow

Vince found that under certain circumstances software event overflows
go wrong and deadlock. Avoid trying to delete a timer from the timer
callback.

Cc: stable@kernel.org
Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/core.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..32a6151 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5016,11 +5016,8 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
 		event->pending_kill = POLL_HUP;
-		if (nmi) {
-			event->pending_disable = 1;
-			irq_work_queue(&event->pending);
-		} else
-			perf_event_disable(event);
+		event->pending_disable = 1;
+		irq_work_queue(&event->pending);
 	}
 
 	if (event->overflow_handler)


