Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1LIROP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:14:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60320 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1LIROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:14:14 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=gD6wIu1_qO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=7LyvK8m3GhTwadWsJ8AA:9 a=U2LyI_Yo0zXnYN1nwG4A:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH 3/3] x86: Add workaround to NMI iret woes
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <20111209164917.GA2444@redhat.com>
References: <20111208193003.112037550@goodmis.org>
	 <20111208193136.366941904@goodmis.org> <1323373012.30977.123.camel@frodo>
	 <1323398616.30977.167.camel@frodo>  <20111209164917.GA2444@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 12:14:11 -0500
Message-ID: <1323450851.1937.28.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 11:49 -0500, Jason Baron wrote:
> > 
> 
> Then, I'm wondering if the same technique can be used for the original
> nmi->int3->nmi case. That is, switch the IDT when the int3 comes in, so
> that the subsequent nmi will be handled on the debug stack. As you pointed out,
> these nesting and thus the IDT switching would be rare in
> practice. (I know you don't want to touch any code outside of nmi :))

Right, I NMIs are ugly and we shouldn't uglify other code because of it.

Anyway, when could we do the switch in the int3 handler? As I said, the
NMI could come in at that moment the int3 is being processed, before it
does anything. If the NMI hits an int3, it just stomped over the
previous int3's interrupt frame.

The more I look at this, the more I like the original idea.

-- Steve


