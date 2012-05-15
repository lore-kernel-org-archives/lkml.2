Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166Ab2EORnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:43:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966101Ab2EORnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:43:16 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=huzqtivG31QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=YgrQR-ftoE5f_ynzeJUA:9 a=I0bfbeDaUa_0ewUhiJYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337103795.14207.343.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Tue, 15 May 2012 13:43:15 -0400
In-Reply-To: <1337103096.27694.94.camel@twins>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	 <1337094383.27694.62.camel@twins>
	 <1337096542.14207.315.camel@gandalf.stny.rr.com>
	 <1337102732.14207.336.camel@gandalf.stny.rr.com>
	 <1337103096.27694.94.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 19:31 +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-15 at 13:25 -0400, Steven Rostedt wrote:
> > On Tue, 2012-05-15 at 11:42 -0400, Steven Rostedt wrote:
> > > On Tue, 2012-05-15 at 17:06 +0200, Peter Zijlstra wrote:
> > > > On Tue, 2012-05-15 at 10:03 -0400, Steven Rostedt wrote:
> > > > > 
> > > > > where readers may nest (the same task may grab the same rwsem for
> > > > > read multiple times), but only one task may hold the rwsem at any
> > > > > given
> > > > > time (for read or write).
> > > > 
> > > > Humm, that sounds iffy, rwsem isn't a recursive read lock only rwlock_t
> > > > is.
> > > 
> > > In that case, current -rt is broken. As it has it being a recursive lock
> > > (without my patch).
> 
> Nah not broken, just pointless. A recursive lock that's not used
> recursively is fine.

Heh, sure :-) But as -rt keeps it recursive, I didn't want to change
that.

> 
> > 
> > Why wouldn't it be recursive. If two different tasks are allowed to grab
> > a read lock at the same time, why can't the same task grab a read lock
> > twice? As long as it releases it the same amount of times.
> > 
> > Now you can't grab a read lock if you have the write lock.
> 
> rwsem is fifo-fair, if a writer comes in between the second read
> acquisition (even by the same task) would block and you'd be a deadlock
> since the write won't succeed since you're still holding a reader.

Yep agreed. And this patch didn't change that either.

-- Steve


