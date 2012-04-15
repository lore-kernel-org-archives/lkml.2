Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2DOKvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:51:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52257 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2DOKvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:51:40 -0400
Message-ID: <1334487062.2528.113.camel@twins>
Subject: Re: [RFC 0/6] uprobes: kill uprobes_srcu/uprobe_srcu_id
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Sun, 15 Apr 2012 12:51:02 +0200
In-Reply-To: <20120414205200.GA9083@redhat.com>
References: <20120405222024.GA19154@redhat.com>
	 <1334409396.2528.100.camel@twins> <20120414205200.GA9083@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 22:52 +0200, Oleg Nesterov wrote:
> > >     - can it work or I missed something "in general" ?
> >
> > So we insert in the rb-tree before we take mmap_sem, this means we can
> > hit a non-uprobe int3 and still find a uprobe there, no?
> 
> Yes, but unless I miss something this is "off-topic", this
> can happen with or without these changes. If find_uprobe()
> succeeds we assume that this bp was inserted by uprobe.

OK, but then I completely missed what the point of that 
down_write() stuff is..
