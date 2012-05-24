Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab2EXJoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:44:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45795 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2EXJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:44:01 -0400
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of
 arch registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <1337801535-12865-2-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:43:56 +0200
Message-ID: <1337852636.9783.89.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> +static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
> +{
> +       switch (idx) {
> +       case PERF_X86_32_REG_EAX:
> +               return regs->ax;
> +       case PERF_X86_32_REG_EBX:
> +               return regs->bx;
> +       case PERF_X86_32_REG_ECX:
> +               return regs->cx;
> +       case PERF_X86_32_REG_EDX:
> +               return regs->dx;
> +       case PERF_X86_32_REG_ESI:
> +               return regs->si;
> +       case PERF_X86_32_REG_EDI:
> +               return regs->di;
> +       case PERF_X86_32_REG_EBP:
> +               return regs->bp;
> +       case PERF_X86_32_REG_ESP:
> +               return regs->sp;
> +       case PERF_X86_32_REG_EIP:
> +               return regs->ip;
> +       case PERF_X86_32_REG_FLAGS:
> +               return regs->flags;
> +       case PERF_X86_32_REG_CS:
> +               return regs->cs;
> +       case PERF_X86_32_REG_DS:
> +               return regs->ds;
> +       case PERF_X86_32_REG_ES:
> +               return regs->es;
> +       case PERF_X86_32_REG_FS:
> +               return regs->fs;
> +       case PERF_X86_32_REG_GS:
> +               return regs->gs;
> +       }
> +
> +       return 0;
> +} 

This is just sad... is there really no saner way to write this? I
suppose you're going to iterate your sample_regs bitmap and call this
function for every bit. GCC isn't known to generate particularly sane
code for switches :/

