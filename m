Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2HTPrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:47:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42423 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2HTPrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:47:03 -0400
Message-ID: <1345477609.23018.61.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 20 Aug 2012 17:46:49 +0200
In-Reply-To: <20120820153225.GA20258@redhat.com>
References: <20120724203613.GA9637@redhat.com>
	 <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com>
	 <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins>
	 <20120820145919.GB18499@redhat.com> <1345475434.23018.48.camel@twins>
	 <1345476436.23018.54.camel@twins> <20120820153225.GA20258@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 17:32 +0200, Oleg Nesterov wrote:

> > I guess we could steal the entire list and requeue it afterwards and
> > lift TIF_NOTIFY_RESUME along with it..
> 
> We can't. This can race with exit_task_work(). And this can break
> fput(), the task can return to the userspace without __fput().

So we could put that spinlock back around cancel and run and leave add
lockless. That'd solve my immediate problem but its not something I'm
proud of.

All schemes I can come up with end up being broken or effectively the
same as the above proposal.
