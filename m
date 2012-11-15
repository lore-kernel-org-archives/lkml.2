Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2KOV3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:29:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2KOV3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:29:39 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_41qGextLBQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M0QJ2o_OXdsA:10 a=yPCof4ZbAAAA:8 a=Syg2NRCwGl7ZE89Qe-cA:9 a=PUjeQqilurYA:10 a=7DSvI1NPTFQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1353013550.7837.2.camel@gandalf.local.home>
Subject: Re: [patch] ftrace: clear bits properly in reset_iter_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 15 Nov 2012 16:05:50 -0500
In-Reply-To: <1339261076.13377.90.camel@gandalf.stny.rr.com>
References: <20120609161027.GD6488@elgon.mountain>
	 <1339261076.13377.90.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Doing my slow clean ups, I find lots of coins under the couch cushions)

On Sat, 2012-06-09 at 12:57 -0400, Steven Rostedt wrote:
> On Sat, 2012-06-09 at 19:10 +0300, Dan Carpenter wrote:
> > There is a typo here where '&' is used instead of '|' and it turns the
> > statement into a noop.  The original code is equivalent to:
> > 
> > 	iter->flags &= ~((1 << 2) & (1 << 4));
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This is a static checker fix and I'm not super familiar with ftrace.
> > Please review carefully.
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index a008663..97da2dc 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -2358,7 +2358,7 @@ static void reset_iter_read(struct ftrace_iterator *iter)
> >  {
> >  	iter->pos = 0;
> >  	iter->func_pos = 0;
> > -	iter->flags &= ~(FTRACE_ITER_PRINTALL & FTRACE_ITER_HASH);
> > +	iter->flags &= ~(FTRACE_ITER_PRINTALL | FTRACE_ITER_HASH);
> 
> Thanks! This is a real minor bug, but as it is a simple fix I will
> probably queue it up for 3.5 and stable. The reason that it has gone
> unnoticed for so long is that this would only show up if you did a lseek
> on the function list file. Which is not a common operation to do.
> 
> I checked the code and if someone were to do an lseek with these flags
> set then they would just get the hash list again (and not the function
> list). It's a bug, yes, but not a big one.
> 
> I'll queue it up on Monday.
> 

I just didn't say *which* Monday :-p

Bah, this got lost in a rebase somehow. Grumble, I should push this out
now as urgent.

-- Steve

> 
> >  }
> >  
> >  static void *t_start(struct seq_file *m, loff_t *pos)
> 


