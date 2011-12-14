Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1LNS13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:27:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32935 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab1LNS12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:27:28 -0500
Message-ID: <4EE8EA61.9050902@zytor.com>
Date: Wed, 14 Dec 2011 10:26:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86: Allow NMIs to hit breakpoints in i386
References: <20111214025237.457632996@goodmis.org> <20111214025253.519573056@goodmis.org>
In-Reply-To: <20111214025253.519573056@goodmis.org>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 06:52 PM, Steven Rostedt wrote:
> With i386, NMIs and breakpoints use the current stack and they
> do not reset the stack pointer to a fix point that might corrupt
> a previous NMI or breakpoint (as it does in x86_64). But NMIs are
> still not made to be re-entrant, and need to prevent the case that
> an NMI hitting a breakpoint (which does an iret), doesn't allow
> another NMI to run.

Okay... what about the other way around: avoiding the IRET when invoked
from an NMI context and therefore leaving NMI disabled until the
appropriate time?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

