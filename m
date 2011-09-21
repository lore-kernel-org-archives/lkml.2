Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1IUQMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:12:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53207 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1IUQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:12:03 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=eNfrWi43AAIueW9vo1oA:9 a=m-EZD___HdxYXRn30cAA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1109211046350.14676@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <alpine.DEB.2.00.1109191644190.19059@router.home>
	 <1316487977.29966.32.camel@gandalf.stny.rr.com>
	 <20110920154610.GB28952@Krystal>
	 <1316534441.29966.79.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201109470.8056@router.home>
	 <1316544841.29966.121.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109211007450.12914@router.home>
	 <1316619103.29966.139.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109211046350.14676@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 21 Sep 2011 12:12:01 -0400
Message-ID: <1316621521.29966.148.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 10:59 -0500, Christoph Lameter wrote:
> On Wed, 21 Sep 2011, Steven Rostedt wrote:
> 
> > The problem I have with this, is that this does not help at all. We are
> > back to the word "this_cpu" when you really do mean "any_cpu". We
> 
> We mean the current cpu while the instruction is executing.

Yes, again that is a implementation detail not a design one. The
"current cpu" is nothing more than an optimization. The code is still
written in a way that it would work if you wrote it to another CPU as
long as the operation itself was atomic.

> 
> > Again, lets just bite the bullet and rename them to something that is
> > understandable for everyone. This would make all of us happy.
> >
> > I'm not against your code, I'm against the naming convention you decided
> > to use. It makes it confusing to something that is complex and complex
> > code needs to try to be a simple as possible.
> 
> I am certainly open to new ways of structuring the stuff and for any
> improvement possible. This whole scheme was developed in long discussions
> over many years. My initial proposal was to use cpu_inc/dec etc. I did
> what was possible in the context of the various opinions that people had
> on these matters when the implementations were discussed. The "you" does
> not apply. It is either "us" or "them" (if you want to distance yourself
> from this).

Who is this "them"? Currently the only ones that matter to me is the
mainline kernel developers. They are the ones that have to live with
this nonsense. If the "them" includes other mainline kernel developers
that are not on the Cc, please add them. Otherwise, I really don't give
a flying fart about the "them".

This is all about a naming convention, not the implementation. The
current naming convention is extremely confusing. As the mistakes that
have been shown through out the kernel. Worse yet, you removed the debug
features that have been there forever and don't even care. Just calling
the users that break the code irresponsible is not going to get you
anywhere.

We have already talked about bringing this up at Kernel Summit. Too bad
you wont be there. Make sure one of the "them" is there to defend this
silly naming convention, otherwise I will push to get all the main
kernel developers accepting a renaming of this internal API. And
immediately after the conference I will start sending patches that will
be accepted.

-- Steve


