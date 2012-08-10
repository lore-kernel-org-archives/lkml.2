Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084Ab2HJDJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:09:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2HJDJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:09:07 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=3rytjJLIguwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=lZymThCyQD2SXi_tcfEA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344568144.6935.97.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracepoints: Move the work out of line from
 hotpath sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 09 Aug 2012 23:09:04 -0400
In-Reply-To: <20120810020523.GA18832@Krystal>
References: <1344544823.6935.82.camel@gandalf.stny.rr.com>
	 <20120809205053.GB15109@Krystal>
	 <1344551131.6935.90.camel@gandalf.stny.rr.com>
	 <502444CC.8030906@linux.intel.com> <50244D9A.2070000@gmail.com>
	 <1344562886.6935.93.camel@gandalf.stny.rr.com>
	 <20120810020523.GA18832@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 22:05 -0400, Mathieu Desnoyers wrote:

> In your example, is the attribute attached to the if() or the following
> basic block ? Attaching it to the basic block allows a nice level of
> genericity:

Yes, I meant the block, not the if().

Heck, any block could be done this way, even just a block insertion...

void foo(int bar) {
	[...]

	__attribute__((section("mysection")) {
		/* code here is in 'mysection' */
	}
	[...]
}

All gcc would have to do is place a hard jump to the code in the
section, and have the section jump back.

-- Steve


