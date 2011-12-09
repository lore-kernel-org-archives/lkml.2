Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1LIJWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:22:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56727 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LIJWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:22:49 -0500
Message-ID: <1323422521.17673.47.camel@twins>
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Date: Fri, 09 Dec 2011 10:22:01 +0100
In-Reply-To: <1323398616.30977.167.camel@frodo>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 21:43 -0500, Steven Rostedt wrote:
> On Thu, 2011-12-08 at 14:36 -0500, Steven Rostedt wrote:
> 
> > I'm not sure how to handle this case. We could do something similar in
> > the break point code to handle the same thing. But this just seems
> > really ugly.
> > 
> > Anyone with any better ideas?
> 
> On IRC, Peter Zijlstra mentioned changing the IDT in NMI. I'm not sure
> if he was joking or not. But I decided to try it out. It seems to
> work :)

Its was definitely tongue in cheek, also I did say this'll be a massive
pain with paravirt since I doubt paravirt calls are NMI safe. 

But yeah, it might all be slightly less painful than trying to teach the
INT3 handler about this recursion.

This all started with wanting to do pagefaults from NMI context, those
too will have this recursion, although for faults we'll end up in the
double fault handler, which seems to allow a slightly saner way out.
