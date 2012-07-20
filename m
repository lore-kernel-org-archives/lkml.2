Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2GTRCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:02:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50197 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2GTRCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:02:08 -0400
Message-ID: <1342803700.2583.29.camel@twins>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Date: Fri, 20 Jul 2012 19:01:40 +0200
In-Reply-To: <20120720165213.GD32763@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
	 <1342802391.2583.11.camel@twins> <20120720165213.GD32763@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 09:52 -0700, Tejun Heo wrote:
> Ooh, yeah, I agree.  That's next on the wq to-do list.  The problem is
> that queue_work() is implemented in terms of queue_work_on().  

But that's trivial to fix, both could use __queue_work() without too
much bother, right?

> In most
> cases, the local binding serves as locality optimization than anything
> else.  There are use cases where affinity is required for correctness.

> The assumption was that they should flush during CPU_DOWN but it
> probably will be much better to require users which need CPU affinity
> to always use queue_work_on() - instead of implicit local affinity
> from queue_work() - and flush them automatically from wq callback.
> 

Right, and when you create this new mode, which you need to know to
flush on DOWN, you can simply put a BUG_ON in queue_work_on() when this
mode is set.


