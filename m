Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529Ab2FDMru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:47:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51084 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753385Ab2FDMrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:47:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/+GPpzLvP+EMrMtGbuczaXppe84Fb1q0r5BVBsS9
	xpvE1IXJpbw7hx
Message-ID: <1338814063.7356.192.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 14:47:43 +0200
In-Reply-To: <1338810796.28282.32.camel@twins>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 13:53 +0200, Peter Zijlstra wrote: 
> On Mon, 2012-06-04 at 11:25 +0200, Mike Galbraith wrote:
> > Isn't this poking the wrong spot?
> 
> Yes and no, the use-case is definitely so-so.. However, even if a FIFO
> task were to only consume 95% of time, we might still want to balance
> things differently, and I don't think we do the sane thing there either.

You need a good reason to run RT, and being able to starve others to
death ain't it, so I don't see a good reason to care about the 95% case
enough to fiddle with load balancing to accommodate the oddball case.

Agreed it is a hole, but it's one dug by root.  If you need so much CPU
that you can and will starve SCHED_OTHER to death, you need isolation
from SCHED_OTHER, lest they do evil things to your deadline, just as
much as they desperately need protection from your evil CPU usage ;-)

-Mike

