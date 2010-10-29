Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482Ab0J2NKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 09:10:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735Ab0J2NKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 09:10:49 -0400
Date: Fri, 29 Oct 2010 15:10:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, David Daney <ddaney@caviumnetworks.com>,
        rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101029131027.GA28124@elte.hu>
References: <cover.1288212485.git.jbaron@redhat.com>
 <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com>
 <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
 <20101028141757.GA2875@redhat.com>
 <4CC9C724.3020004@caviumnetworks.com>
 <20101028201112.GA4792@redhat.com>
 <20101029063450.GE29463@elte.hu>
 <1288354687.18238.433.camel@gandalf.stny.rr.com>
 <20101029122230.GA25663@elte.hu>
 <1288356418.18238.454.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288356418.18238.454.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2010-10-29 at 14:22 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Fri, 2010-10-29 at 08:34 +0200, Ingo Molnar wrote:
> 
> > > Do you mean to have it dependent on !EMBEDDED, or perhaps !CC_OPTIMIZE_FOR_SIZE ?
> > 
> > CC_OPTIMIZE_FOR_SIZE dependency probably not. Might even leave out !EMBEDDED, to 
> > make it generally configurable.
> > 
> > Also, we should make it default off - we need to see whether there are any compiler 
> > bugs lurking.
> 
> Ah, so we should then add a:
> 
> config JUMP_LABEL
> 	prompt "Optimize trace point call sites"
> 	depends on HAVE_ARCH_JUMP_LABEL
> 	help
> 	  If it is detected that the compiler has support for
> 	  "asm goto", the kernel will compile trace points locations 
> 	  with just a nop instruction. When trace points are enabled
> 	  the nop will be converted to a jump to the trace function.
> 	  This technique lowers overhead and stress on the branch
> 	  prediction of the processor.
> 
> 	  On i386, the options added to make this work may increase
> 	  the size of the kernel slightly.

Yeah.

> Then in the code have:
> 
> -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
> +#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL) \
> +	&& defined(JUMP_LABEL)
>  # include <asm/jump_label.h>
>  # define HAVE_JUMP_LABEL
>  #endif
> 
> 
> If you agree, I can write up a patch.

Yeah. Thanks!

	Ingo
