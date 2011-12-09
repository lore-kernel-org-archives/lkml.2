Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1LIPLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:11:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32858 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1LIPLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:11:33 -0500
Message-ID: <1323443432.16764.2.camel@twins>
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
Date: Fri, 09 Dec 2011 16:10:32 +0100
In-Reply-To: <1323442828.1937.17.camel@frodo>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org>  <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>  <1323422521.17673.47.camel@twins>
	 <1323442828.1937.17.camel@frodo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 10:00 -0500, Steven Rostedt wrote:
> On Fri, 2011-12-09 at 10:22 +0100, Peter Zijlstra wrote:
> 
> > Its was definitely tongue in cheek, also I did say this'll be a massive
> > pain with paravirt since I doubt paravirt calls are NMI safe. 
> 
> But does paravirt simulate NMIs? Does a guest ever take an NMI? I can
> enable paravirt to see if it breaks. 

KVM does NMIs, the write_idt thing is a paravirt call. Then again, a
vcpu is a single thread of execution, there can only ever be 1 hypercall
at the same time.

The only thing that remains is if the hypercall interface is NMI-safe,
what if the NMI comes in just as another context is also starting a
hypercall. I really don't know enough about all that crap to know.


