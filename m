Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0IMJh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:37:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:48116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab0IMJhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:37:55 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284369373.14710.11.camel@marge.simson.net>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
	 <1284366936.2275.27.camel@laptop>
	 <1284369373.14710.11.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 11:37:40 +0200
Message-ID: <1284370660.2275.86.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:16 +0200, Mike Galbraith wrote:
> On Mon, 2010-09-13 at 10:35 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-09-13 at 09:08 +0200, Mike Galbraith wrote:
> > > We need a better fork fairness gizmo.
> > 
> > Proper zero-lag insertion would do. Much sadness in that tracking that
> > costs a u64 mult per enqueu/dequeue and using it adds a s64 div.
> 
> (math _sucks_:)
> 
> > But if you want, have a play with:
> 
> maximum latency: 48475.3 µs
> average latency: 6881.4 µs
> missed timer events: 0
> 
> Darn.
> 
> make -j3 is gaining a tad over a hog as well, roughly the same as
> turning START_DEBIT off.


Hrmm,. could it be fair_sleeper muck placing too many tasks too far left
on wakeup starving others?
