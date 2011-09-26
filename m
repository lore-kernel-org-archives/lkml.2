Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1IZQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:26:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:41938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1IZQ0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:26:15 -0400
Subject: Re: [PATCH v5 3.1.0-rc4-tip 12/26]   Uprobes: Handle breakpoint and
 Singlestep
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 26 Sep 2011 18:25:22 +0200
In-Reply-To: <20110926160144.GC13535@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
	 <20110920120221.25326.74714.sendpatchset@srdronam.in.ibm.com>
	 <1317045553.1763.23.camel@twins>
	 <20110926160144.GC13535@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317054322.1763.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 21:31 +0530, Srikar Dronamraju wrote:
> * Peter Zijlstra <peterz@infradead.org> [2011-09-26 15:59:13]:
> 
> > On Tue, 2011-09-20 at 17:32 +0530, Srikar Dronamraju wrote:
> > > 						Hence provide some extra
> > > + * time (by way of synchronize_sched() for breakpoint hit threads to acquire
> > > + * the uprobes_treelock before the uprobe is removed from the rbtree. 
> > 
> > 'Some extra time' doesn't make me all warm an fuzzy inside, but instead
> > screams we fudge around a race condition.
> 
> The extra time provided is sufficient to avoid the race. So will modify
> it to mean "sufficient" instead of "some".   
> 
> Would that suffice?

Much better, for extra point, explain why its sufficient as well ;-)
