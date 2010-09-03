Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0ICPjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:39:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33799 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0ICPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:39:40 -0400
X-Authority-Analysis: v=1.1 cv=jsU1gHzFqI0vjyg35dbbhFRlpVAv39iqdMS5PbCl9Js= c=1 sm=0 a=ePs-FBDEYOsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=t2Ef24gi_xIh8OsbHP4A:9 a=e2IjE4BjBAkhmH3NPOR2X9hZtkcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v4 1/5] irq: add tracepoint to softirq_raise
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Koki Sanagi <sanagi.koki@jp.fujitsu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com,
        eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca
In-Reply-To: <20100903152909.GA5352@nowhere>
References: <4C72422C.5070102@jp.fujitsu.com>
	 <4C724298.4050509@jp.fujitsu.com>  <20100903152909.GA5352@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Sep 2010 11:39:36 -0400
Message-ID: <1283528376.2356.436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 17:29 +0200, Frederic Weisbecker wrote:

> >  #define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
> >  #define show_softirq_name(val)				\
> > @@ -93,7 +95,10 @@ DECLARE_EVENT_CLASS(softirq,
> >  	),
> >  
> >  	TP_fast_assign(
> > -		__entry->vec = (int)(h - vec);
> > +		if (vec)
> > +			__entry->vec = (int)(h - vec);
> > +		else
> > +			__entry->vec = *((int *)h);
> >  	),
> 
> 
> 
> It seems that this will break softirq_entry/exit tracepoints.
> __entry->vec will deref vec->action() for these two, which is not
> what we want.

But for trace_softirq_entry and trace_softirq_exit, vec will not be
NULL.


> 
> If you can't have the same tracepoint signature for the three, just
> split the new one in a seperate TRACE_EVENT().

It may be a bit of a hack, and questionable about adding another
TRACE_EVENT(). There still is a pretty good space savings in using
DEFINE_EVENT() over TRACE_EVENT() though.

-- Steve



