Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1BBSrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:47:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35855 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1BBSrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:47:20 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=TcmrmW5AdGEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=EkUvijt2la3SQ4SF6QMA:9 a=5ocYduS9dXRX4qBkIZEA:7 a=i0PnJcsBojM9OgLfjIKz16nGJUMA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] Tracepoints: Fix section alignment using pointer
 array
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20110202183138.GB27022@Krystal>
References: <20110202180613.978219945@goodmis.org>
	 <20110202180938.471738176@goodmis.org>  <20110202183138.GB27022@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 13:47:17 -0500
Message-ID: <1296672437.10797.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:31 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > 
> > Make the tracepoints more robust, making them solid enough to handle compiler
> > changes by not relying on anything based on compiler-specific behavior with
> > respect to structure alignment. Implement an approach proposed by David Miller:
> > use an array of const pointers to refer to the individual structures, and export
> > this pointer array through the linker script rather than the structures per se.
> > It will consume 32 extra bytes per tracepoint (24 for structure padding and 8
> > for the pointers), but are less likely to break due to compiler changes.
> > 
> > History:
> > 
> > commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> > variable attribute to the tracepoint structures to deal with gcc happily
> > aligning statically defined structures on 32-byte multiples.
> > 
> > commit 15e3540ce2159705f18fad6147ffedf04445ad64 tried to use a 8-byte alignment
> > for tracepoint structures by applying both the variable and type attribute to
> > tracepoint structures definitions and declarations. It worked fine with gcc
> > 4.5.1, but broke with gcc 4.4.4 and 4.4.5.
> 
> Small nit: this reference to commit 15e3540ce2159705f18fad6147ffedf04445ad64
> should be changed to a non-commit-id-related explanation, because the commit has
> been rolled back from -tip.

Yeah, I noticed this too, right after I posted it.

> 
> The rest looks good.

OK, I'll rebase by just removing the reverted commit reference.

Thanks,

-- Steve


