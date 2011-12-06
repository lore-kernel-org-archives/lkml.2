Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab1LFQ4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:56:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1LFQ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:56:46 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7FkR-CEZipcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=tZJsTpUVjTTo_ghUwK4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
In-Reply-To: <20111206160455.GC2325@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
	 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111205091924.GA28117@zhy> <20111205164505.GB2326@linux.vnet.ibm.com>
	 <20111206012635.GA32498@zhy> <1323165152.32012.51.camel@twins>
	 <20111206100537.GA5203@zhy> <1323167527.32012.61.camel@twins>
	 <1323174405.30977.86.camel@frodo>
	 <20111206160455.GC2325@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 11:56:42 -0500
Message-ID: <1323190602.30977.94.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-06 at 08:04 -0800, Paul E. McKenney wrote:

> > Perhaps the real answer is that we need to create an API for priority
> > inheritance, that things like RCU could use. Attach a task that another
> > task requires to finish something and boost the priority of that task.
> > Maybe even completions could use such a thing?
> 
> I would be OK with that -- that was in fact the approach I was taking
> when I was advised to use mutexes instead.  ;-)

Maybe we should rethink it. Using the makeshift mutex looks to be a
short term hack. But if we are starting to build on it, it will end up
being a horrible design, based off of a hack.

A mutex is to provide mutual exclusion. If we start bastardizing it to
do other things, it will become unmaintainable. I dare say that it's
close to unmaintainable now ;)

If we create a new API to handle inheritance, then perhaps it could be
used for other things like workqueues and completions (in -rt only).

-- Steve


