Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0LPPgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:36:00 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:34133 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab0LPPf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:35:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hZr+SYctlgvD/A1NkGNa3nxOps3lFtcl0hZG76RYgCdJvsXEhb9emxT1HYmVgdjcWl
         oqBYCk6lg+schOJfyIgJAl78MQ6HP6PRl6VJbLbIp25HEiGpvaJvWzL7aMgm2lGPa73w
         69d1kpX0EMX3T7NXzLg71g6KjsoPSugFwsBog=
Date: Thu, 16 Dec 2010 16:35:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/5] sched: Change the ttwu success details
Message-ID: <20101216153550.GD1687@nowhere>
References: <20101216145602.899838254@chello.nl>
 <20101216150920.866959114@chello.nl>
 <20101216152351.GB1687@nowhere>
 <1292513275.6803.4603.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292513275.6803.4603.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 04:27:55PM +0100, Peter Zijlstra wrote:
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


Yep, builtin-sched.c and sched-migration.py do.
