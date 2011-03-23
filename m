Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1CWAi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:38:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1CWAi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:38:56 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=5AMJFd0FRxYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=XLqB0lIPG9OXm2_-bjwA:9 a=HshHQRdaLdJBQ8DfJxoA:7 a=JZg1e7ccK2tC_2GXhGVTQuOc14IA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Deadlock scenario in regulator core
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110323000100.GB2529@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org>
	 <1300835998.14261.13.camel@gandalf.stny.rr.com>
	 <20110323000100.GB2529@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 20:38:54 -0400
Message-ID: <1300840734.14261.72.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 00:01 +0000, Mark Brown wrote:
> On Tue, Mar 22, 2011 at 07:19:58PM -0400, Steven Rostedt wrote:
> 
> > Looks to me that the mutex_lock() in _notifier_call_chain needs to be a
> > mutex_lock_nested().
> 
> > The "_nested()" versions are when you have the same type of mutex taken
> > but belonging to two different instances. Like you have here:
> 
> What's a mutex type?  I have to say this is the first time I've heard of
> mutex types and the documentation in mutex.c and mutex-design.txt isn't
> precisely verbose on what mutex_lock_nested() is for or how one would
> pick subclass.

Sorry, I said "mutex type" as a synonym to "lock class". A lock class is
pretty much how a lock is defined.

struct foo {
	struct mutex	m;
};


struct foo *func(void)
{
	bar = kzalloc(sizeof(*bar));
	mutex_init(&bar->m);
}


bar is an instance of lock class struct foo.m. If you have:

	a = func();
	b = func();

Both a->m and b->m are an instance of struct foo.m lock class.

There's better documentation about this in the lockdep-design.txt.

-- Steve


