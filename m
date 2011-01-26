Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1AZUCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:02:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:39755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZUCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:02:24 -0500
Subject: Re: [tip:sched/core] sched: Untangle cpu-load and timekeeping code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110126122900.GA8387@zhy>
References: <new-submission>
	 <tip-18a57c3b43781ea83c3bb21c3add84ba890d5fb3@git.kernel.org>
	 <20110126122900.GA8387@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 21:03:03 +0100
Message-ID: <1296072183.15234.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 20:29 +0800, Yong Zhang wrote:
> On Wed, Jan 26, 2011 at 12:14:43PM +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> > Gitweb:     http://git.kernel.org/tip/18a57c3b43781ea83c3bb21c3add84ba890d5fb3
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Tue, 25 Jan 2011 11:30:35 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 26 Jan 2011 12:33:23 +0100
> > 
> > sched: Untangle cpu-load and timekeeping code
> > 
> > Remove the calc_global_load() call from the timekeeping code and make
> > it local to the scheduler.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> > +static void calc_global_load(unsigned long __data)
> >  {
> >  	long active;
> >  
> > -	calc_global_nohz(ticks);
> > +	calc_global_nohz();
> >  
> >  	if (time_before(jiffies, calc_load_update + 10))
> >  		return;
> 
> We should not do this checking any more. In normal case,
> it will always return false.
> If it indeed returns true for some reason, we will lose the
> timer forever.

Its needed for the nohz case, arguably we could move it inside
calc_global_nohz().
