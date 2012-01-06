Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab2AFK6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:58:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:39627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab2AFK6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:58:23 -0500
Message-ID: <1325847461.2442.4.camel@twins>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 06 Jan 2012 11:57:41 +0100
In-Reply-To: <20120106061407.GC14946@linux.vnet.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
	 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
	 <1325695788.2697.3.camel@twins> <20120106061407.GC14946@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 11:44 +0530, Srikar Dronamraju wrote:
>         - consumers for the uprobe is NULL, so mmap_uprobe will not
>           insert new breakpoints which correspond to this uprobe until
>           or unless another consumer gets added for the same probe.
> 
>         - If a new consumer gets added for this probe, we reuse the
>           uprobe struct.

Ok, and when we install a new 'first' consumer we'll again try and
install all breakpoints ignoring those that were already there?
