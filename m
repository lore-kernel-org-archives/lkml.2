Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1ITQHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:07:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1ITQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:07:12 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=6qbAnu_Q0HoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=iYnJa5nCYRiJgLvIE2cA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <alpine.DEB.2.00.1109201038150.8056@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.688732950@goodmis.org>
	 <alpine.DEB.2.00.1109191657150.19059@router.home>
	 <1316476089.29966.9.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109200940240.8056@router.home>
	 <1316531769.29966.61.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1109201038150.8056@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 12:07:10 -0400
Message-ID: <1316534830.29966.84.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 10:54 -0500, Christoph Lameter wrote:

> There are significant advantages for counters and things designed to
> operate in an environment where the OS can migrate a task at will.
> Vvmstat and the slub fastpaths exploit these things now and it will be
> possible with these operations to increase the performance of more
> subsystems that way. The page allocator comes to mind.

I'm sorry but correctness beats performance every time! What you have
done seems to be micro optimizations with the sacrifice to correctness.

If you kept the damn this_cpu_*() local to the slab and page allocators,
we may not have even noticed. But you went ahead and made this a very
intrusive invasion into the rest of the kernel, and caused bugs to be
missed everywhere.

-- Steve


