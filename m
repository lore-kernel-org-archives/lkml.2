Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1HEMax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:30:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1HEMat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:30:49 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=WrFlywIw7b8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=zIQgd9ccXfPXfojc1yQA:9 a=MtRyChid-5wAUCn-9r4A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] sched/cpupri: Remove the vec->lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <mgalbraith@suse.de>,
        "Luis Claudio R." =?UTF-8?Q?Gon=EF=BF=BDalves?= 
	<lgoncalv@redhat.com>,
        Matthew Hank Sabins <msabins@linux.vnet.ibm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110805082008.GA6628@zhy>
References: <1312317372.18583.101.camel@gandalf.stny.rr.com>
	 <20110805082008.GA6628@zhy>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 05 Aug 2011 08:30:47 -0400
Message-ID: <1312547447.18583.195.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 16:20 +0800, Yong Zhang wrote:
> On Tue, Aug 02, 2011 at 04:36:12PM -0400, Steven Rostedt wrote:
> > diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> > index 9fc7d38..6b4cd17 100644
> > --- a/kernel/sched_cpupri.h
> > +++ b/kernel/sched_cpupri.h
> > @@ -12,9 +12,8 @@
> >  /* values 2-101 are RT priorities 0-99 */
> >  
> >  struct cpupri_vec {
> > -	raw_spinlock_t lock;
> > -	int        count;
> > -	cpumask_var_t mask;
> > +	atomic_t	count;
> > +	cpumask_var_t	mask;
> >  };
> >  
> >  struct cpupri {
> 
> So cpupri->pri_active and macro CPUPRI_NR_PRI_WORDS is not needed any more?

It doesn't appear so. Looks like they can be removed too.

Want to send a patch?

Thanks!

-- Steve


