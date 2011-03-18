Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1CRTK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:10:59 -0400
Received: from toast.topped-with-meat.com ([168.75.111.31]:45762 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831Ab1CRTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:10:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
X-Fcc: ~/Mail/lkml
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 6/20] 6: x86: analyze instruction and
 determine fixups.
In-Reply-To: Srikar Dronamraju's message of  Saturday, 19 March 2011 00:19:22 +0530 <20110318184922.GA31152@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	<20110314133507.27435.71382.sendpatchset@localhost6.localdomain6>
	<alpine.LFD.2.00.1103151529130.2787@localhost6.localdomain6>
	<20110318182457.GA24048@linux.vnet.ibm.com>
	<20110318183629.2AB052C286@topped-with-meat.com>
	<20110318184922.GA31152@linux.vnet.ibm.com>
X-Windows: the defacto substandard.
Message-Id: <20110318191047.4BAF12C183@topped-with-meat.com>
Date: Fri, 18 Mar 2011 12:10:47 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=K6VZ71qI c=1 sm=1 a=WaHTwlwe2vUA:10
		a=kj9zAlcOel0A:10 a=8PYZixKV93lXvnu6C90A:9 a=CCnuJsjoL3lipwxSKYfDwGtsXwsA:4
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we rewrite the copy of instruction (stored in XOL) such that it
> accesses its memory operand indirectly thro a scratch register.
> The contents of the scratch register are stored before singlestep and
> restored later.

I see.  That should work fine in principle, assuming you use a register
that is not otherwise involved, of course.  I hope you arrange to restore
the register if the copied instruction is never run because of a signal or
suchlike.  In that case, it's important that the signal context get the
original register and original PC rather than the fiddled state for running
the copy.  Likewise, if anyone is inspecting the registers right after the
step.


Thanks,
Roland
