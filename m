Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0IMHet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:34:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751434Ab0IMHes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:34:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/JJWZgbUPJfbAaQzzqGT6GT71xYlE62sv+/IidUF
	Jps48/gPjVLc//
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284361716.25120.19.camel@marge.simson.net>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 13 Sep 2010 09:35:10 +0200
Message-Id: <1284363310.25120.34.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:08 +0200, Mike Galbraith wrote:

> Sticky wicket.  We need a better fork fairness gizmo.

Like maybe re-inventing O(1)'s fork penalty + return on exit instead of
START_DEBIT penalizing the child?  Child of lagging parent needs to run
NOW, just as any other lagging task wakeup, but fork/clone dare not be
an advantage.

	-Mike

