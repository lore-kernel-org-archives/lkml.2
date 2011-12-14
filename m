Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab1LNTdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:33:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1LNTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:33:19 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=Jj81R3xejsoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=C-krsxV6Xh8kvhYOQQkA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323891195.23971.60.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Date: Wed, 14 Dec 2011 14:33:15 -0500
In-Reply-To: <4EE8EA61.9050902@zytor.com>
References: <20111214025237.457632996@goodmis.org>
	 <20111214025253.519573056@goodmis.org> <4EE8EA61.9050902@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 10:26 -0800, H. Peter Anvin wrote:
> On 12/13/2011 06:52 PM, Steven Rostedt wrote:
> > With i386, NMIs and breakpoints use the current stack and they
> > do not reset the stack pointer to a fix point that might corrupt
> > a previous NMI or breakpoint (as it does in x86_64). But NMIs are
> > still not made to be re-entrant, and need to prevent the case that
> > an NMI hitting a breakpoint (which does an iret), doesn't allow
> > another NMI to run.
> 
> Okay... what about the other way around: avoiding the IRET when invoked
> from an NMI context and therefore leaving NMI disabled until the
> appropriate time?

Linus was against this approach. He didn't want the ugliness of NMI to
spread to other code, by adding ugly handlers around the 'iret' of
breakpoints and exceptions.

-- Steve


