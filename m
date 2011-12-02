Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1LBTlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:41:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab1LBTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:41:39 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=WQKrF2fF-hAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=BaxOxmkexsrzpA5TPcIA:9 a=K6DTfC9XNjBpaNmBtMEA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH-RT] Fix for sleeping function called from invalid
 context when running gdb
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20111202182008.GT24062@one.firstfloor.org>
References: <1322833159-3846-1-git-send-email-jkacur@redhat.com>
	 <1322840763.30977.39.camel@frodo>
	 <20111202182008.GT24062@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 14:41:37 -0500
Message-ID: <1322854897.30977.55.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 19:20 +0100, Andi Kleen wrote:
> > > -static inline void preempt_conditional_sti(struct pt_regs *regs)
> > > +static inline void preempt_conditional_sti(struct pt_regs *regs, int stack)
> > >  {
> > > -	inc_preempt_count();
> > > +	if (stack)
> > > +		inc_preempt_count();
> 
> All callers now pass in true I think, so you could eliminate the stack argument.

Not in RT:

#ifdef CONFIG_PREEMPT_RT_FULL
# define STACKFAULT_STACK 0
# define DOUBLEFAULT_STACK 1
# define NMI_STACK 2
# define DEBUG_STACK 0
# define MCE_STACK 3
# define N_EXCEPTION_STACKS 3  /* hw limit: 7 */
#else
# define STACKFAULT_STACK 1
# define DOUBLEFAULT_STACK 2
# define NMI_STACK 3
# define DEBUG_STACK 4
# define MCE_STACK 5
# define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
#endif


-- Steve


