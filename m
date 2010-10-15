Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0JOURZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:17:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0JOURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:17:23 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=PDCcCwAOpv8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=6wJHxvniHZISyS_QRLIA:9 a=8nv3U3jE9n8ixI5PzlwA:7 a=vypKHyxGh5sRswfsqYHLQck7fTkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/9] [GIT PULL] jump label: various updates
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101015200949.134732894@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 16:17:22 -0400
Message-ID: <1287173842.16971.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> Ingo,
> 
> Please pull the latest tip/perf/jump-label tree, which can be found at:

Hold on, I forgot to add Jason Baron's fix for compiling against < 4.5.

I'll add that and push it out as jump-label-2

-- Steve

> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/perf/jump-label
> 
> 
> David Daney (2):
>       jump label: Make arch_jump_label_text_poke_early() optional
>       jump label: Add MIPS support.
> 
> Jason Baron (6):
>       jump label/x86: Move arch_init_ideal_nop5 later
>       jump label: Fix module __init section race
>       jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex
>       jump label: Add register_jump_label_key/unregister_jump_label_key
>       jump label: Move jump table to r/w section
>       jump label: Add docs
> 
> Steven Rostedt (1):
>       tracing/x86: No need to disable interrupts when calling arch_init_ideal_nop5
> 
> ----
>  Documentation/jump-label.txt        |  142 ++++++++++++++++++++++
>  arch/mips/Kconfig                   |    1 +
>  arch/mips/include/asm/jump_label.h  |   48 ++++++++
>  arch/mips/kernel/Makefile           |    3 +-
>  arch/mips/kernel/jump_label.c       |   50 ++++++++
>  arch/mips/kernel/module.c           |    5 +
>  arch/sparc/include/asm/jump_label.h |    1 +
>  arch/x86/include/asm/jump_label.h   |    1 +
>  arch/x86/kernel/alternative.c       |    5 +
>  arch/x86/kernel/setup.c             |    6 -
>  include/asm-generic/vmlinux.lds.h   |   14 +--
>  include/linux/jump_label.h          |   15 +++
>  kernel/jump_label.c                 |  222 ++++++++++++++++++++++++++++++-----
>  kernel/kprobes.c                    |    6 +
>  kernel/trace/ftrace.c               |    4 +-
>  kernel/tracepoint.c                 |   34 ++++++
>  lib/dynamic_debug.c                 |   20 +++
>  17 files changed, 526 insertions(+), 51 deletions(-)


