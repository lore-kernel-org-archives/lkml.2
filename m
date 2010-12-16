Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0LPPbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:31:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33076 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab0LPPbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:31:05 -0500
Subject: Re: [RFC][PATCH 3/5] sched: Change the ttwu success details
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <1292513275.6803.4603.camel@twins>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.866959114@chello.nl>  <20101216152351.GB1687@nowhere>
	 <1292513275.6803.4603.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 16:30:15 +0100
Message-ID: <1292513415.6803.4604.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 16:27 +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 16:23 +0100, Frederic Weisbecker wrote:
> 
> > > -	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
> > > +	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
> > >  		  __entry->comm, __entry->pid, __entry->prio,
> > > -		  __entry->success, __entry->target_cpu)
> > > +		  __entry->target_cpu)
> > 
> > Note we'll need to fix some perf scripts after that. And also perf sched,
> > probably perf timechart and so on...
> 
> Do any of those actually use the success parameter? If not, then me
> removing it shouldn't break those tools since they're supposed to parse
> the format stuff and not notice it missing ;-)

Alternatively we could always call trace_sched_wakeup() and make success
reflect actual wakeup success.
