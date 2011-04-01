Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1DAKxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:53:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab1DAKxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:53:53 -0400
Subject: Re: [RFC] [PATCH] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4D94EF4B.6070905@gmail.com>
References: <4D94EF4B.6070905@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 12:53:14 +0200
Message-ID: <1301655194.4859.479.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 01:16 +0400, Cyrill Gorcunov wrote:
> Because of Netburst HW restriction we can't move events arbitrary
> between counters and this makes 'perf top' unable to run if nmi-watchdog
> is running (since both uses PERF_COUNT_HW_CPU_CYCLES but such event is
> bound to run on a few counters only). So as a workaround we could count that named
> non-sleeping ticks (as oprofile does) and both perf top and nmi-watchdog would co-exsist
> without conflicts but kernel needs to know about such specifics -- so PERF_COUNT_HW_NMI_WATCHDOG
> event is introduced. This event is an alias of PERF_COUNT_HW_CPU_CYCLES for non-P4 x86
> architecture so nothing much changed I think.
> 
> Please review, I might be missing something. Also comments on idea is quite welcome since
> it touches ABI part.


>  arch/x86/kernel/cpu/perf_event_amd.c   |    1 +
>  arch/x86/kernel/cpu/perf_event_intel.c |    1 +
>  arch/x86/kernel/cpu/perf_event_p4.c    |   15 +++++++++++++++
>  arch/x86/kernel/cpu/perf_event_p6.c    |    1 +
>  include/linux/perf_event.h             |    1 +
>  kernel/watchdog.c                      |    2 +-
>  6 files changed, 20 insertions(+), 1 deletions(-)

is x86 the only arch using the watchdog things?
