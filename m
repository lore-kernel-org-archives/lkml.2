Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1A1GX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 01:23:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1A1GX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 01:23:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 13/20] 13: x86: x86 specific probe
 handling
In-Reply-To: Srikar Dronamraju's message of  Friday, 28 January 2011 10:27:21 +0530 <20110128045721.GV19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	<20101216095947.23751.75003.sendpatchset@localhost6.localdomain6>
	<1295963783.28776.1061.camel@laptop>
	<20110127094041.GR19725@linux.vnet.ibm.com>
	<1296123733.15234.53.camel@laptop>
	<20110127191146.DB22F180999@magilla.sf.frob.com>
	<20110128045721.GV19725@linux.vnet.ibm.com>
X-Zippy-Says: I know how to get the hostesses released!  Give them their own
    television series!
Message-Id: <20110128062316.9515018099A@magilla.sf.frob.com>
Date: Thu, 27 Jan 2011 22:23:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uprobes doesn't request/handle block-step for now. So can we postpone
> your suggested changes till uprobes needs to handle block-step?

That's not the issue.  The way the hardware works is that if the bit is set
in the MSR, then the TF eflags bit means block-step instead of single-step.
So if PTRACE_SINGLEBLOCK has been used (i.e. user_enable_block_step), then
this can interfere with your use of single-step.  You need to do the work
in the else branch of step.c:enable_step to ensure that the hardware is not
left in the state where it will do block-step instead of single-step when
uprobes wants a single-step done.


Thanks,
Roland
