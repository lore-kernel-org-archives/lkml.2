Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1CRSrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 14:47:00 -0400
Received: from toast.topped-with-meat.com ([168.75.111.31]:40841 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab1CRSqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 14:46:53 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 14:46:53 EDT
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
In-Reply-To: Srikar Dronamraju's message of  Friday, 18 March 2011 23:54:57 +0530 <20110318182457.GA24048@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	<20110314133507.27435.71382.sendpatchset@localhost6.localdomain6>
	<alpine.LFD.2.00.1103151529130.2787@localhost6.localdomain6>
	<20110318182457.GA24048@linux.vnet.ibm.com>
X-Windows: the joke that kills.
Message-Id: <20110318183629.2AB052C286@topped-with-meat.com>
Date: Fri, 18 Mar 2011 11:36:29 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=K6VZ71qI c=1 sm=1 a=WaHTwlwe2vUA:10
		a=kj9zAlcOel0A:10 a=HmEWQsaWwob7zDLwClAA:9 a=1A_kdLFkw_G9ZIfHBwAA:7
		a=vMOMKWXsHKddFGYuQVTn8bsjAaQA:4 a=CjuIK1q_8ugA:10 a=j4CujHGUVanNbcFM:21
		a=slv4dBQuIyfjkoTa:21 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> handle_riprel_insn() returns 0 if the instruction is not rip-relative
> returns 1 if its rip-relative but can use XOL slots.
> returns -1 if its rip-relative but cannot use XOL.
> 
> We dont see any instructions that are rip-relative and cannot use XOL.
> so the check and return are redundant and I will remove that in the next
> patch.

How is that?  You can only adjust a rip-relative instruction correctly if
the instruction copy is within 2GB of the original target address, which
cannot be presumed to always be the case in user address space layout
(unlike the kernel).

Thanks,
Roland
