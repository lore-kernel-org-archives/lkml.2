Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab2HHMtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:49:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33216 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab2HHMtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:49:11 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=ZD8vtu1JDTEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=eMo4KRmQjVAHfHF2L-4A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344430148.6935.17.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry
 is used
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Wed, 08 Aug 2012 08:49:08 -0400
In-Reply-To: <5021EC6B.7020605@hitachi.com>
References: <20120807193845.146666357@goodmis.org>
	 <20120807194059.773895870@goodmis.org> <5021EC6B.7020605@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 13:34 +0900, Masami Hiramatsu wrote:
>  
> > -#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
> > +#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_USING_FENTRY)
> 
> I think CONFIG_HAVE_FENTRY would better unselect
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST in arch/x86/Kconfig explicitly.

No, CONFIG_HAVE_FENTRY just means fentry is supported, it does not mean
that it is being used. It only gets used if CC_USING_FENTRY is set,
which is set by the Makefile at time of compile.

If CONFIG_HAVE_FENTRY is defined, a test is done to see if the gcc
compiling the kernel supports -mfentry. If it does, then it defines the
CC_USING_FENTRY macro, if not, the macro is not defined and the old way
is performed.

If the old way is performed, even if CONFIG_HAVE_FENTRY is defined, then
we still need the above test. We can not have CONFIG_HAVE_FENTRY
unselect CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST.

-- Steve


