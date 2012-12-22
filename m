Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2LVAyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:54:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28212 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LVAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:54:32 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OoO1U_lqWwkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rxlOrqzforUA:10 a=_7kRLFjJg8bF9nMhGowA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121222003019.433916240@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 21 Dec 2012 19:30:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <clark.williams@gmail.com>
Subject: [RFC][PATCH 0/2] sched: Allow interrupts to be enabled in idle balance
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idle_balance() code is treated special in the scheduler for
no real apparent reason. There's an unlikely check for !rq->nr_running
in the hot path of the scheduler, for just the idle load balancing.

As sched classes can have their own post schedule routine, and the
idle task has its own scheduler class, we can move the idle_balance()
into the idle task's post schedule routine, and out of the hot path
of the scheduler (no sepecial check).

An added benefit for doing this is that this enables us to enable
interrupts in the idle balance code. Shrinking the time interrupts
are disabled while doing load balancing.

These patches have been thoroughly tested (on a 40 core box as well
as a 4 core and UP config), and are prime for inclusion (for 3.9).
But I'm posted them now as an RFC for comments.

Thanks!

-- Steve

