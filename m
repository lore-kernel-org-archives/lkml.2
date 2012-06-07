Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2FGJqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:46:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45713 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FGJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:46:37 -0400
Date: Thu, 7 Jun 2012 11:46:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 01/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120607094624.GB19842@somewhere.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
 <1337801535-12865-2-git-send-email-jolsa@redhat.com>
 <1337852636.9783.89.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337852636.9783.89.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:43:56AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-05-23 at 21:32 +0200, Jiri Olsa wrote:
> > +static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
> > +{
> > +       switch (idx) {
> > +       case PERF_X86_32_REG_EAX:
> > +               return regs->ax;
> > +       case PERF_X86_32_REG_EBX:
> > +               return regs->bx;
> > +       case PERF_X86_32_REG_ECX:
> > +               return regs->cx;
> > +       case PERF_X86_32_REG_EDX:
> > +               return regs->dx;
> > +       case PERF_X86_32_REG_ESI:
> > +               return regs->si;
> > +       case PERF_X86_32_REG_EDI:
> > +               return regs->di;
> > +       case PERF_X86_32_REG_EBP:
> > +               return regs->bp;
> > +       case PERF_X86_32_REG_ESP:
> > +               return regs->sp;
> > +       case PERF_X86_32_REG_EIP:
> > +               return regs->ip;
> > +       case PERF_X86_32_REG_FLAGS:
> > +               return regs->flags;
> > +       case PERF_X86_32_REG_CS:
> > +               return regs->cs;
> > +       case PERF_X86_32_REG_DS:
> > +               return regs->ds;
> > +       case PERF_X86_32_REG_ES:
> > +               return regs->es;
> > +       case PERF_X86_32_REG_FS:
> > +               return regs->fs;
> > +       case PERF_X86_32_REG_GS:
> > +               return regs->gs;
> > +       }
> > +
> > +       return 0;
> > +} 
> 
> This is just sad... is there really no saner way to write this? I
> suppose you're going to iterate your sample_regs bitmap and call this
> function for every bit. GCC isn't known to generate particularly sane
> code for switches :/
> 

Do you think that compat regs are always a subset of native regs in all
archs as in x86? Sounds logic but I'm asking just in case. If so then yeah
this should work.
