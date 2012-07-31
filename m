Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab2GaSWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:22:34 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45214 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2GaSWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:22:32 -0400
Date: Tue, 31 Jul 2012 11:21:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: __update_max_tr: rcu_read_lock() used illegally while idle!
Message-ID: <20120731182114.GN2422@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1343741625.27983.39.camel@gandalf.stny.rr.com>
 <20120731144453.GB2422@linux.vnet.ibm.com>
 <1343746311.27983.52.camel@gandalf.stny.rr.com>
 <1343746583.27983.55.camel@gandalf.stny.rr.com>
 <20120731151808.GF2422@linux.vnet.ibm.com>
 <1343749502.27983.57.camel@gandalf.stny.rr.com>
 <20120731171733.GK2422@linux.vnet.ibm.com>
 <1343755497.27983.59.camel@gandalf.stny.rr.com>
 <20120731174440.GM2422@linux.vnet.ibm.com>
 <1343758001.27983.66.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343758001.27983.66.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073118-5518-0000-0000-0000067BE221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:06:41PM -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 10:44 -0700, Paul E. McKenney wrote:
> 
> > OK, I interpret this as excluding NMI handlers, but please let me
> > know if I am still being naive.  ;-)
> > 
> 
> You are correct. This is only called where lockdep is called (to trace
> enabling of IRQS). Note, that its called before normal irqs are actually
> enabled (interrupts are still disabled), this is why it's called outside
> of the in_irq() sections, because it is called just before returning
> back to process context.
> 
> That said, because NMIs are so difficult, lockdep doesn't record the
> disabling (and then enabling) of interrupts when an NMI triggers. Thus,
> the irqsoff tracer also does not record NMIs. Which is fine, because
> NMIs should not take long to run (we can add other mechanisms to time
> NMI length if that is needed), and NMIs should not be enabling
> interrupts nor taking any locks.
> 
> >From arch/x86/kernel/entry_64.S:
> 
> 	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */

Then the patch on my earlier email should do it for you.

							Thanx, Paul

