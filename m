Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab1COTqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:46:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab1COTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:46:30 -0400
Subject: Re: [PATCH v2 2.6.38-rc8-tip 4/20] 4: uprobes: Adding and remove a
 uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1103151916120.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133444.27435.50684.sendpatchset@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103151425060.2787@localhost6.localdomain6>
	 <20110315173041.GB24254@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.1103151916120.2787@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 20:48:19 +0100
Message-ID: <1300218499.2250.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 20:22 +0100, Thomas Gleixner wrote:
> I am not sure if its a good idea to walk the tree
> > as and when the tree is changing either because of a insertion or
> > deletion of a probe.
> 
> I know that you cannot walk the tree lockless except you would use
> some rcu based container for your probes. 

You can in fact combine a seqlock, rb-trees and RCU to do lockless
walks.

  https://lkml.org/lkml/2010/10/20/160

and

  https://lkml.org/lkml/2010/10/20/437

But doing that would be an optimization best done once we get all this
working nicely.

