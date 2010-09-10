Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0IJRpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:45:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21053 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0IJRpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:45:06 -0400
Date: Fri, 10 Sep 2010 10:43:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Florian Mickler <florian@mickler.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH UPDATED] workqueue: add documentation
Message-Id: <20100910104324.6079a0b3.randy.dunlap@oracle.com>
In-Reply-To: <4C8A46D9.5020303@kernel.org>
References: <4C87AE52.70401@kernel.org>
	<4C87B101.2080608@kernel.org>
	<20100909100229.250900f0@schatten.dmk.lab>
	<4C88B55E.90203@kernel.org>
	<20100909205056.1ac7989a@schatten.dmk.lab>
	<4C8A07B3.1050603@kernel.org>
	<20100910162658.254b224a@schatten.dmk.lab>
	<4C8A46D9.5020303@kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Sep 2010 16:55:21 +0200 Tejun Heo wrote:

> +3. The Design

> +Subsystems and drivers can create and queue work items through special
> +workqueue API functions as they see fit. They can influence some
> +aspects of the way the work items are executed by setting flags on the
> +workqueue they are putting the work item on. These flags include
> +things like cpu locality, reentrancy, concurrency limits and more. To

               CPU

> +get a detailed overview refer to the API description of
> +alloc_workqueue() below.

> +4. Application Programming Interface (API)

> +@flags:
> +
> +  WQ_NON_REENTRANT
> +
> +	By default, a wq guarantees non-reentrance only on the same
> +	CPU.  A work may not be executed concurrently on the same CPU

	        work item

> +	by multiple workers but is allowed to be executed concurrently
> +	on multiple CPUs.  This flag makes sure non-reentrance is
> +	enforced across all CPUs.  Work items queued to a
> +	non-reentrant wq are guaranteed to be executed by at most one
> +	worker system-wide at any given time.

> +  WQ_CPU_INTENSIVE
> +
> +	Work items of a CPU intensive wq do not contribute to the
> +	concurrency level.  In other words, Runnable CPU intensive

	                                    runnable

> +	work items will not prevent other work items from starting
> +	execution.  This is useful for bound work items which are
> +	expected to hog CPU cycles so that their execution is
> +	regulated by the system scheduler.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
