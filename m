Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1BBS45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:56:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1BBS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:56:57 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=TcmrmW5AdGEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pEz5wUr9R-py2zkukaoA:9 a=x-YUg8UnV5p82sjPp8AUT1xVAj4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
Date: Wed, 02 Feb 2011 13:56:55 -0500
Message-ID: <1296673015.10797.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 13:31 -0500, Mathieu Desnoyers wrote:

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

OK, I just did a git commit --amend to fix it. Here's the new text:


    commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type a
    variable attribute to the tracepoint structures to deal with gcc happily
    aligning statically defined structures on 32-byte multiples.
    
    One attempt was to use a 8-byte alignment for tracepoint structures by apply
    both the variable and type attribute to tracepoint structures definitions an
    declarations. It worked fine with gcc 4.5.1, but broke with gcc 4.4.4 and 4.
    
    The reason is that the "aligned" attribute only specify the _minimum_ alignm
    for a structure, leaving both the compiler and the linker free to align on
    larger multiples. Because tracepoint.c expects the structures to be placed a
    array within each section, up-alignment cause NULL-pointer exceptions due to
    extra unexpected padding.

This version has just been pushed. I just changed the wording to leave
out the reference to the reverted commit.

-- Steve


