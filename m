Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2F0O6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:58:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50109 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab2F0O6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:58:41 -0400
Date: Wed, 27 Jun 2012 16:58:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/23] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120627145831.GF20638@somewhere.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-3-git-send-email-jolsa@redhat.com>
 <20120620164233.GB7714@somewhere.redhat.com>
 <20120620173900.GB1768@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620173900.GB1768@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 07:39:00PM +0200, Jiri Olsa wrote:
> On Wed, Jun 20, 2012 at 06:42:36PM +0200, Frederic Weisbecker wrote:
> > On Tue, Jun 19, 2012 at 05:47:53PM +0200, Jiri Olsa wrote:
> 
> SNIP
> 
> > > diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
> > > new file mode 100644
> > > index 0000000..0397bfc
> > > --- /dev/null
> > > +++ b/arch/x86/include/asm/perf_regs.h
> > > @@ -0,0 +1,34 @@
> > > +#ifndef _ASM_X86_PERF_REGS_H
> > > +#define _ASM_X86_PERF_REGS_H
> > > +
> > > +enum perf_event_x86_regs {
> > > +	PERF_REG_X86_AX,
> > > +	PERF_REG_X86_BX,
> > > +	PERF_REG_X86_CX,
> > > +	PERF_REG_X86_DX,
> > > +	PERF_REG_X86_SI,
> > > +	PERF_REG_X86_DI,
> > > +	PERF_REG_X86_BP,
> > > +	PERF_REG_X86_SP,
> > > +	PERF_REG_X86_IP,
> > > +	PERF_REG_X86_FLAGS,
> > > +	PERF_REG_X86_CS,
> > > +	PERF_REG_X86_DS,
> > > +	PERF_REG_X86_ES,
> > > +	PERF_REG_X86_FS,
> > > +	PERF_REG_X86_GS,
> > > +	PERF_REG_X86_R8,
> > > +	PERF_REG_X86_R9,
> > > +	PERF_REG_X86_R10,
> > > +	PERF_REG_X86_R11,
> > > +	PERF_REG_X86_R12,
> > > +	PERF_REG_X86_R13,
> > > +	PERF_REG_X86_R14,
> > > +	PERF_REG_X86_R15,
> > > +	PERF_REG_X86_SS,
> > > +
> > > +	/* non ABI */
> > > +	PERF_REG_X86_64_MAX = PERF_REG_X86_SS + 1,
> > 
> > SS also exist in 32 bits, right?
> > Although I guess userspace doesn't care much.
> 
> yes it's there

But PERF_REG_X86_SS is above PERF_REG_X86_32_MAX.
