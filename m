Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0EFImQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:42:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:37462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0EFImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:42:14 -0400
Message-ID: <4BE280AA.6020304@kernel.org>
Date: Thu, 06 May 2010 10:41:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move perf
 on top of TP
References: <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org> <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org> <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop> <1273083396.1642.251.camel@laptop> <20100505183000.GF6320@nowhere> <20100506062855.GD1172@elte.hu> <4BE26B96.4040007@kernel.org> <20100506082714.GA2036@elte.hu>
In-Reply-To: <20100506082714.GA2036@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 08:41:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 05/06/2010 10:27 AM, Ingo Molnar wrote:
> Note that preempt notifiers used to modify scheduling behavior/semantics i'm 
> really against. Please get that functionality into the scheduler - especially 
> if it's essentially always-on.

Okay.  Well, cmwq's usage of it isn't that hairy.  It's used for two
things.

1. to count the number of currently running workers which I think is
   fine for such hooks.

2. to wake up another worker.  I don't think this falls in the
   category of "behavior/semantics" change.  It just does
   try_to_wake_up() with the only caveat being it's called under the
   rq lock so requires a different API.  There's nothing which alters
   the scheduler behavior in any pervasive way.  It just looks at the
   counter and wakes up another task if the condition is right
   *before* beginning any of real scheduling work.

But, anyways, making a dedicated fixed function calls certainly isn't
a problem and might as well be slightly cheaper as it's always gonna
be there anyway.  If that's preferred, I'll happily take that path.

Thanks.

-- 
tejun
