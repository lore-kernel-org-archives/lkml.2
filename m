Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2GaPTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:19:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45706 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab2GaPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:19:05 -0400
Date: Tue, 31 Jul 2012 08:18:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
Message-ID: <20120731151808.GF2422@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120724090330.GA9830@localhost>
 <1343662752.3847.2.camel@fedora>
 <20120731120556.GB17252@localhost>
 <1343741625.27983.39.camel@gandalf.stny.rr.com>
 <20120731144453.GB2422@linux.vnet.ibm.com>
 <1343746311.27983.52.camel@gandalf.stny.rr.com>
 <1343746583.27983.55.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343746583.27983.55.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073115-2356-0000-0000-000000DCA1DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:56:23AM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 10:51 -0400, Steven Rostedt wrote:
> 
> > > OK, I will bite.  How about using something like RCU_NONIDLE(), either
> > > directly or open-coded, to make it a legal call site?
> > 
> > OK, then something like:
> > 
> > 	RCU_NONIDLE(max_data = task_uid(tsk));
> > 
> > would work when called normally or with idle?
> > 
> 
> The comment above RCU_NONIDLE() says:
> 
> 	This macro may be used from process-level code only.
> 
> Although I'm not sure what a 'level' is. Do you mean process-context? If
> so, then this will not work because it can be called from non process
> level code (return from interrupt), or any interrupt that enables
> interrupts.

Yep, process context.  It seems that I was naively expecting the
calls in interrupt context to be covered by rcu_irq_enter() and
rcu_irq_exit().  I take it that these calls are happening outside of
the rcu_irq_enter()-protected region?

							Thanx, Paul

