Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2HTQUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:20:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:56457 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HTQT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:19:58 -0400
Message-ID: <1345479590.23018.75.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 18:19:50 +0200
In-Reply-To: <20120820161012.GC21400@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins>
	 <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins>
	 <20120820161012.GC21400@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 18:10 +0200, Oleg Nesterov wrote:
> task->task_works points to the last node in the circular single-linked list,
> task_work_add() adds the new element after the last one and updates
> task->task_works. This is O(1).

Agreed, the way I was looking at that is: ->task_works points to the
head and we put a new one in front, that too is O(1) ;-)

> > > But the list should be short, we can reverse it in _run() if we change
> > > task_work_add() to add to the head.
> >
> > Reversing a (single linked) list is O(n^2)..
> 
> Hmm. This is O(n). You can simply iterate over this list once, changing
> the ->next pointer to point back. 

OK, I'm going to stop and step away from the computer now.. clearly I
more than useless today :/

But yeah.. that could be done.

Anyway, would taking ->pi_lock over _cancel and _run suffice?
