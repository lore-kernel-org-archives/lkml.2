Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1LHTg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:36:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1LHTg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:36:56 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Z-H3xPG-LD8O-Opvu1kA:9 a=C7lhwuqMPV4X8PbBKucA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <20111208193136.366941904@goodmis.org>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 14:36:52 -0500
Message-ID: <1323373012.30977.123.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 14:30 -0500, Steven Rostedt wrote:

> If the first NMI hits a breakpoint and loses NMI context, and then it
> hits another breakpoint and while processing that breakpoint we get a
> nested NMI. When processing a breakpoint, the stack changes to the
> breakpoint stack. If another NMI comes in here we can't rely on the
> interrupted stack to be the NMI stack. 

As I wrote this part of the change log, I thought of another nasty
gotcha with breakpoints in NMIs.

If you have a breakpoint in both normal context and NMI context. When
the breakpoint is being processed, if an NMI comes in and it too
triggers a breakpoint, this processing of the breakpoint has the same
problem as nested NMIs. The NMI breakpoint handler will corrupt the
stack of the breakpoint that was being processed when the NMI triggered.

I'm not sure how to handle this case. We could do something similar in
the break point code to handle the same thing. But this just seems
really ugly.

Anyone with any better ideas?

-- Steve


