Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2EaLSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:18:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2EaLSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:18:17 -0400
Message-ID: <1338463085.28384.54.camel@twins>
Subject: Re: [PATCH 2/5] ftrace: Use breakpoint method to update ftrace
 caller
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 13:18:05 +0200
In-Reply-To: <20120531020440.839498007@goodmis.org>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.839498007@goodmis.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 21:28 -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> On boot up and module load, it is fine to modify the code directly,
> without the use of breakpoints. This is because boot up modification
> is done before SMP is initialized, thus the modification is serial,
> and module load is done before the module executes.
> 
> But after that we must use a SMP safe method to modify running code.
> 
> This has been done to change the nops at all the functions, but
> the change of the ftrace callback handler itself was still using a
> direct modification. If tracing was enabled and the function callback
> was changed then another CPU could fault if it was currently calling
> the original callback. This modification must use the breakpoint method
> too.
> 
> Note, the direct method is still used for boot up and module load.

The changelog isn't clear if this is a fix or optimization. I suspect
the latter.

Still, you're now re-inventing text_poke() and text_poke_early().

Why are you keeping all this inside of ftrace?


