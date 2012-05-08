Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2EHMsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:48:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2EHMsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:48:35 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=tIgcOtFmeE8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ko-s2C6j605yG1vGA9gA:9 a=XqYOjYFXzENVXT-Sh8wA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336481312.14207.164.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v20] tracing: Fix kconfig warning due to a typo
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>
Date: Tue, 08 May 2012 08:48:32 -0400
In-Reply-To: <1336476588.16236.20.camel@twins>
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
	 <1336476588.16236.20.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 13:29 +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-08 at 16:41 +0530, Srikar Dronamraju wrote:
> > +    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
> 
> can you also do things like:
> 
>  p:uprobes/ponies /bin/zsh:foo arg1=bar
> 
> when bar is either a function argument of foo (or an otherwise live
> variable at the probe point)?
> 
> Only sampling register content is somewhat limiting, you might want to
> have %ax[5] + 24 for example, or a pure memory deref -- and the dwarves
> know where it all lives.

But this is for the raw entry into the kernel. The kernel wont know the
variable name. Although perf could do that parsing for you.

That said, the %ax[5] + 24 could be done in kernel, and that would be
useful. Does kprobes handle that?

-- Steve


