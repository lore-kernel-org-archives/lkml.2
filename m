Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0LPPpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:45:45 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63783 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0LPPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vnxk/AhhBwb3u/jzrkZ98nwdsOHUvQjMtRPUueexPDzs6ZVU2nZKPPOniZr77LtooD
         ll1ydpF6vlRmin8O1Xj34t7NxASIhTAkiNaQyZpgbKy4877nASeIpQ2VStQlFFNSx2go
         Eo8kt/qMbUdmEAjDiivgM0iKIzen3CaUYv8iU=
Date: Thu, 16 Dec 2010 16:45:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/5] sched: Change the ttwu success details
Message-ID: <20101216154533.GE1687@nowhere>
References: <20101216145602.899838254@chello.nl>
 <20101216150920.866959114@chello.nl>
 <20101216152351.GB1687@nowhere>
 <1292513275.6803.4603.camel@twins>
 <1292513415.6803.4604.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292513415.6803.4604.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 04:30:15PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 16:27 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-12-16 at 16:23 +0100, Frederic Weisbecker wrote:
> > 
> > > > -	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
> > > > +	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
> > > >  		  __entry->comm, __entry->pid, __entry->prio,
> > > > -		  __entry->success, __entry->target_cpu)
> > > > +		  __entry->target_cpu)
> > > 
> > > Note we'll need to fix some perf scripts after that. And also perf sched,
> > > probably perf timechart and so on...
> > 
> > Do any of those actually use the success parameter? If not, then me
> > removing it shouldn't break those tools since they're supposed to parse
> > the format stuff and not notice it missing ;-)
> 
> Alternatively we could always call trace_sched_wakeup() and make success
> reflect actual wakeup success.

So, that would work very well for sched-migration.py

builtin-sched.c would continue to work fine but would notice that as
a bug if a wake up occur on a task already running.

But it will only trigger a warning, besides that it will just continue
to work normally.

It's ok I think, if that old tool triggers a spurious warning. I suspect
very few people use it anyway.
