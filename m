Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2EaP3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:29:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13441 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab2EaP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:29:22 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=A73EdQgzBtYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=IKFqG1DyJxL6CYKRz1cA:9 a=PUjeQqilurYA:10 a=0nTr5d7jX5bxvTU5:21 a=gD-hWwyS5pZPhJgn:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338478160.13348.355.camel@gandalf.stny.rr.com>
Subject: Re: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 11:29:20 -0400
In-Reply-To: <4FC78B45.9060806@hitachi.com>
References: <20120531012829.160060586@goodmis.org>
	  <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <4FC78B45.9060806@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 00:16 +0900, Masami Hiramatsu wrote:


> Perhaps, kprobes-*jump*-optimization may be better to handle it
> because the target probe is simultaneously working while
> optimizing (modifying code). This means that if someone hits
> breakpoint of such kprobe, it must be handled by kprobes, not
> only just tweaking IP address.

Yeah, ftrace is easier on what the breakpoint does. For kprobes, it's a
bit more invasive. Ftrace only deals with a nop, or a "trace-me" call.
As the modifications are being done, we always treat it as a nop until
the modification is complete.

With kprobes, the text_poke() is a bit more difficult, because it can't
treat the location as a nop, as what is changing actually performs some
task for the kernel. It requires that the breakpoint know what to do
with the text (out-of-line execution, and such). ftrace has the benefit
of just "skip this instruction" and return.

-- Steve


