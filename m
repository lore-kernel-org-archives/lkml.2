Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab2BBVRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:17:14 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:47747 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2BBVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:17:13 -0500
Date: Thu, 2 Feb 2012 22:17:09 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
Message-ID: <20120202211709.GA1642@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning is easily reproducible after todays
'perf-urgent-for-mingo' merge by just running "perf top":

------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/perf_event.c:989 x86_pmu_start+0xa5/0x100()
Hardware name: System Product Name
Pid: 0, comm: swapper/2 Not tainted 3.3.0-rc2-00068-g24b36da-dirty #22
Call Trace:
 <IRQ>  [<ffffffff81054ba0>] ? warn_slowpath_common+0x60/0xa0
 [<ffffffff8103e1a5>] ? x86_pmu_start+0xa5/0x100
 [<ffffffff8109f062>] ? perf_adjust_freq_unthr_context.part.82+0xe2/0x140
 [<ffffffff8109f260>] ? perf_event_task_tick+0x1a0/0x280
 [<ffffffff81078be3>] ? scheduler_tick+0xc3/0x140
 [<ffffffff810615b5>] ? update_process_times+0x55/0x80
 [<ffffffff8108904d>] ? tick_sched_timer+0x4d/0xa0
 [<ffffffff81072d1b>] ? __run_hrtimer.isra.32+0x3b/0xc0
 [<ffffffff810735e5>] ? hrtimer_interrupt+0xc5/0x1e0
 [<ffffffff81045de3>] ? smp_apic_timer_interrupt+0x63/0xa0
 [<ffffffff8147768b>] ? apic_timer_interrupt+0x6b/0x70
 <EOI>  [<ffffffff81039100>] ? default_idle+0x20/0x40
 [<ffffffff81039172>] ? amd_e400_idle+0x52/0x100
 [<ffffffff81030156>] ? cpu_idle+0xb6/0xe0
---[ end trace 7dc3992f562261b6 ]---


-- 
Markus
