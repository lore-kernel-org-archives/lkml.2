Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2BDSJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:09:04 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:56946 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2BDSJD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:09:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120204135110.GA6437@elte.hu>
References: <20120202211709.GA1642@x4>
	<20120202213220.GB1642@x4>
	<CABPqkBTutb5TuNVXZ4o+MzXczVSwk3NtsJh73KZS58xmrd=tbg@mail.gmail.com>
	<20120204135110.GA6437@elte.hu>
Date: Sat, 4 Feb 2012 19:09:00 +0100
Message-ID: <CABPqkBTvoNBBdzvS-njoFk+SrTf-BKQSvP54C05un+m7RA+nBg@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/cpu/perf_event.c:989
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on it. It is hard to reproduce for me.

On Sat, Feb 4, 2012 at 2:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> there's yet another one triggering at:
>
> [89214.962603] ------------[ cut here ]------------
> [89214.967441] WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()
> [89214.975825] Hardware name: X8DTN
> [89214.979268] Modules linked in:
> [89214.982560] Pid: 0, comm: swapper/6 Not tainted 3.3.0-rc2-tip+ #1
> [89214.988865] Call Trace:
> [89214.991533]  <IRQ>  [<ffffffff81065cc7>] warn_slowpath_common+0x7e/0x97
> [89214.998379]  [<ffffffff81065cf5>] warn_slowpath_null+0x15/0x17
> [89215.004428]  [<ffffffff8103f626>] x86_pmu_start+0x79/0xd4
> [89215.010042]  [<ffffffff810e30d1>] perf_adjust_freq_unthr_context.part.63+0xef/0x123
> [89215.018123]  [<ffffffff810e318c>] perf_event_task_tick+0x87/0x1c1
> [89215.024463]  [<ffffffff810a2370>] ? tick_nohz_handler+0xda/0xda
> [89215.030595]  [<ffffffff8108b819>] scheduler_tick+0xd1/0xf3
> [89215.036296]  [<ffffffff810720b0>] update_process_times+0x5e/0x6f
> [89215.042512]  [<ffffffff810a23e0>] tick_sched_timer+0x70/0x99
> [89215.048387]  [<ffffffff810823f9>] __run_hrtimer+0x8c/0x148
> [89215.054087]  [<ffffffff81082add>] hrtimer_interrupt+0xc1/0x18c
>
> Thanks,
>
>        Ingo
