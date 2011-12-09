Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1LIPZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:25:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1LIPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:25:42 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=FsArLiv59tlXlCEZN44A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <1323443432.16764.2.camel@twins>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>  <1323422521.17673.47.camel@twins>
	 <1323442828.1937.17.camel@frodo>  <1323443432.16764.2.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 10:25:29 -0500
Message-ID: <1323444329.1937.22.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 16:10 +0100, Peter Zijlstra wrote:

> KVM does NMIs, the write_idt thing is a paravirt call. Then again, a
> vcpu is a single thread of execution, there can only ever be 1 hypercall
> at the same time.
> 
> The only thing that remains is if the hypercall interface is NMI-safe,
> what if the NMI comes in just as another context is also starting a
> hypercall. I really don't know enough about all that crap to know.

Hmm, well we can detect that we are a paravirt guest or not (that's the
nature of paravirt). We can keep the current methods around, an for
paravirt guests, it will fall back to the old stop_machine() method.
Heck guests have issues with latencies anyway.

For running on bare-metal, we can switch to this method.

-- Steve



