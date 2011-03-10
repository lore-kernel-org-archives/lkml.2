Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1CJDgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:36:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1CJDgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:36:35 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vcVM_-CSrIiTtnZWU30A:9 a=3mDoMQLVNpJEH13kVWXLYUlsRX4A:4 a=PUjeQqilurYA:10 a=8LfsZize8SvTrtSs:21 a=pmob_dQ-TBpnt2XT:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <cover.1299702291.git.jbaron@redhat.com>
References: <cover.1299702291.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 22:36:31 -0500
Message-ID: <1299728191.15854.319.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
> Hi,
> 
> Re-fresh of updates against latest -tip tree.

Thanks Jason,

I started looking at them, I should have comments tomorrow (if I have
any comments ;)

> 
> I've tried to split this update up somewhat, but I've only succeeded to split
> out the dynamic debug bits. The interface changes and re-write are quite
> intertwined.
> 
> I believe this update should address all the comments from the previous posting
> except for Mathieu's request for a section of jump label pointers that point to
> the jump label structures (since the compiler might leave gaps in the jump label
> structures).

The jump label structures is a list of 3 pointers, correct? I doubt that
gcc would place any holes in it as they are all aligned by natural word
size.

>  I've got a prototype patch to address this issue but its somewhat
> invasive, and thus I'd like to leave it as a follow-up item. I have to date,
> not seen this issue in practice.
> 
> thanks,
> 
> -Jason
> 
> 
> Jason Baron (2):
>   jump label: introduce static_branch() interface
>   dynamic debug: add jump label support
> 
>  arch/mips/include/asm/jump_label.h  |   22 +-
>  arch/mips/kernel/jump_label.c       |    2 +-

Could we get Ralf's acked-by for the mips code.

>  arch/sparc/include/asm/jump_label.h |   25 +-

Could we get David Miller's Acked-by for sparc.

Thanks,

-- Steve

>  arch/x86/include/asm/alternative.h  |    3 +-
>  arch/x86/include/asm/jump_label.h   |   26 +-
>  arch/x86/kernel/alternative.c       |    2 +-
>  arch/x86/kernel/jump_label.c        |    2 +-
>  arch/x86/kernel/module.c            |    1 +
>  include/asm-generic/vmlinux.lds.h   |   14 +-
>  include/linux/dynamic_debug.h       |   44 +++-
>  include/linux/jump_label.h          |   86 ++++---
>  include/linux/jump_label_ref.h      |   44 ---
>  include/linux/perf_event.h          |   26 +-
>  include/linux/tracepoint.h          |   22 +-
>  kernel/jump_label.c                 |  537 ++++++++++++++---------------------
>  kernel/perf_event.c                 |    4 +-
>  kernel/tracepoint.c                 |   23 +-
>  lib/dynamic_debug.c                 |    4 +-
>  18 files changed, 391 insertions(+), 496 deletions(-)
>  delete mode 100644 include/linux/jump_label_ref.h


