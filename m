Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1LHTbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:31:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1LHTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:31:38 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Jd-ifAPnx3sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=JXczQkXa6zGHAA8djbQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111208193003.112037550@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Dec 2011 14:30:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 0/3] x86: Find a way to allow breakpoints in NMIs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As been previously discussed on LKML, x86 has an issue with NMIs and iret.
If an NMI takes an exception or breakpoint, iret that those handlers do
will take the CPU out of NMI context, which could allow another NMI to
come in and corrupt the stack.

Linus has discussed a way to solve this and I tried to implement it.
What I came up with was a bit different, but I'm posting it now to get
some feedback from it. See patch 3. I wrote a very detailed change log
there and wont repeat it here.

Let me know what everyone thinks.

Thanks!

-- Steve

---


Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Steven Rostedt (2):
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes

----
 arch/x86/kernel/entry_64.S |  209 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 176 insertions(+), 33 deletions(-)
