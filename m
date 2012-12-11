Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab2LKOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:16:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2LKOQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:16:55 -0500
X-Authority-Analysis: v=2.0 cv=JuRzXbEC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DhgVYC8l6PEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PwOMEcHXvqEA:10 a=jMLkpBkaKqqricricgYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355235413.17101.293.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: frank.rowand@am.sony.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 11 Dec 2012 09:16:53 -0500
In-Reply-To: <1355234577.17101.288.camel@gandalf.local.home>
References: <20121207235615.206108556@goodmis.org>
	 <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
	 <50C68922.5030203@am.sony.com>
	 <1355190830.17101.280.camel@gandalf.local.home>
	 <alpine.LFD.2.02.1212111326310.3028@ionos>
	 <1355234577.17101.288.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 09:02 -0500, Steven Rostedt wrote:

> Currently, what we have is a huge contention on both the pulled CPU rq
> lock. We've measured over 500us latencies due to it. This hurts even the
> CPU that has the overloaded task, as the contention is on its lock.

The 500us latency was one of the max ones I saw, and I believe it was
combined with the load balancer going off at the same time as the pulls
were happening. I've seen larger latencies with limited function tracing
enabled and the load balancer was very involved.

As I believe we have users that would very much want this in, and if you
are still not sure you like this "feature" I can make it into a
SCHED_FEAT() like TTWU_QUEUE. Then you can keep this off and the big
boxes can enable them.

Maybe enable the feature by default if the box has more than 16 cpus?

-- Steve


