Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2JMGyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 02:54:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57165 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2JMGyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 02:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120914191535.GA5992@joi.lan>
References: <20120712213305.GA11128@sli.dy.fi>
	<20120914191535.GA5992@joi.lan>
Date: Sat, 13 Oct 2012 09:54:19 +0300
X-Google-Sender-Auth: 3ShyObrXFZeBO106k5MhHa7orBs
Message-ID: <CAOJsxLGeS0Dv1CnJ1gsmOOPqhQ4vQQUNkkGGYzzsccUd195pWA@mail.gmail.com>
Subject: Re: kmemcheck: Fatal error; system fails to boot when kmemcheck enabled
From: Pekka Enberg <penberg@kernel.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Sami Liedes <sami.liedes@iki.fi>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:15 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> [    3.017200] ------------[ cut here ]------------
> [    3.017203] ------------[ cut here ]------------
> [    3.017208] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
>
> this is WARN_ON_ONCE(in_nmi());
>
> [    3.017209] Hardware name: System Product Name
> [    3.017210] Modules linked in:
> [    3.017211] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc5+ #1147
> [    3.017212] Call Trace:
> [    3.017217]  <NMI>  [<ffffffff9006f12a>] warn_slowpath_common+0x7a/0xb0
> [    3.017219]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
> [    3.017220]  [<ffffffff90069c89>] kmemcheck_fault+0xb9/0xd0
> [    3.017222]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
> [    3.017225]  [<ffffffff90364bd2>] ? put_dec+0x72/0x90
> [    3.017226]  [<ffffffff903656f4>] ? number.isra.2+0x304/0x330
> [    3.017228]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [    3.017232]  [<ffffffff906206ef>] page_fault+0x1f/0x30
> [    3.017235]  [<ffffffff903f136f>] ? vt_console_print+0x9f/0x3a0
> [    3.017237]  [<ffffffff903f1334>] ? vt_console_print+0x64/0x3a0
> [    3.017239]  [<ffffffff9006faf8>] ? msg_print_text+0x158/0x1b0
> [    3.017241]  [<ffffffff90070983>] call_console_drivers.constprop.12+0x93/0xb0
> [    3.017242]  [<ffffffff90070b94>] console_unlock+0x1f4/0x460
> [    3.017244]  [<ffffffff900710ae>] vprintk_emit+0x19e/0x520
> [    3.017246]  [<ffffffff90069c89>] ? kmemcheck_fault+0xb9/0xd0
> [    3.017248]  [<ffffffff90615523>] printk+0x5c/0x5e
> [    3.017250]  [<ffffffff90069c89>] ? kmemcheck_fault+0xb9/0xd0
> [    3.017252]  [<ffffffff9006f0e8>] warn_slowpath_common+0x38/0xb0
> [    3.017253]  [<ffffffff9006f175>] warn_slowpath_null+0x15/0x20
> [    3.017255]  [<ffffffff90069c89>] kmemcheck_fault+0xb9/0xd0
> [    3.017256]  [<ffffffff90063d9e>] do_page_fault+0x3ae/0x490
> [    3.017258]  [<ffffffff90368cad>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [    3.017260]  [<ffffffff906206ef>] page_fault+0x1f/0x30
> [    3.017263]  [<ffffffff90048ad2>] ? x86_perf_event_update+0x2/0x70
> [    3.017265]  [<ffffffff9004e591>] ? intel_pmu_save_and_restart+0x11/0x20
> [    3.017266]  [<ffffffff9004e6c1>] intel_pmu_handle_irq+0x121/0x300
> [    3.017268]  [<ffffffff900489d1>] perf_event_nmi_handler+0x21/0x30
> [    3.017271]  [<ffffffff9003c9b6>] nmi_handle.isra.1+0xa6/0x1f0
> [    3.017272]  [<ffffffff9003c910>] ? __register_nmi_handler+0x190/0x190
> [    3.017274]  [<ffffffff9003cc18>] do_nmi+0x118/0x390
> [    3.017277]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70
> [    3.017278]  [<ffffffff90620a76>] end_repeat_nmi+0x1e/0x2e
> [    3.017280]  [<ffffffff9015fb06>] ? __d_free+0x46/0x70

Looking at the trace, we *are* in the perf NMI handler. So I'm
guessing we ought to annotate some of the core perf kmalloc()'s with
__GFP_NOTRACK to make sure kmemcheck does not kick in.
