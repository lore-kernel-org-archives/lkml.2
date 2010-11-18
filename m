Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0KRIzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:55:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab0KRIzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:55:39 -0500
Date: Thu, 18 Nov 2010 09:55:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
Message-ID: <20101118085513.GH26398@elte.hu>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
 <4CE38C53.8090606@kernel.org>
 <20101117120740.GA24972@elte.hu>
 <4CE47ED0.7080901@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE47ED0.7080901@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhart@linux.intel.com> wrote:

> Ideally I would like to see something just like trace_printf()
> without having to define it myself in each of my testcases. [...]

We can make the prctl a single-argument thing, at the cost of not allowing \0 in the 
content. (which is probably sane anyway)

That way deployment is super-simple:

	prctl(35, "My Trace Message");
	...


	if (asprintf(&msg, "My Trace Message: %d\n", 1234) != -1) {
		prctl(35, *msg);
		free(*msg);
	}

Thanks,

	Ingo
