Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1BYUxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:53:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61192 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1BYUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:53:46 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=9ezeExTAcuIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jgJmeGg5yv4qoyyJ69wA:9 a=n9FL8YJotAW5Wgd7EjR0z1ozAasA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [cpuops cmpxchg double V3 3/5] Generic support for
 this_cpu_cmpxchg_double
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <alpine.DEB.2.00.1102251443500.7359@router.home>
References: <20110225173850.486326452@linux.com>
	 <20110225174155.786331687@linux.com>
	 <20110225202837.GC23161@home.goodmis.org>
	 <alpine.DEB.2.00.1102251443500.7359@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Feb 2011 15:53:42 -0500
Message-ID: <1298667222.6376.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 14:44 -0600, Christoph Lameter wrote:
> On Fri, 25 Feb 2011, Steven Rostedt wrote:
> 
> > > +	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));		\
> > > +	VM_BUG_ON((unsigned long)(&pcp2) != (unsigned long)(&pcp1) + sizeof(pcp1));\
> > > +	VM_BUG_ON(sizeof(pcp1) != sizeof(pcp2));			\
> >
> > Since this is a macro, and it looks like all these are constants (sizeof
> > and addresses), couldn't you just do a BUILD_BUG_ON() instead?
> 
> The addresses are not constant.

I was thinking that if these are per_cpu then they would be global and
thus constant. But those are done at link time, which is too late.

OK, nevermind ;)

-- Steve



