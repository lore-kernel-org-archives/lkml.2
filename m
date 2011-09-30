Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1I3J23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:28:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37558 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1I3J22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:28:28 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 11:27:45 +0200
In-Reply-To: <20110930034815.GF10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317374865.19415.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:48 -0700, Tejun Heo wrote:
> IIRC, this was because there was no way to set PF_THREAD_BOUND once a
> kthread starts to run and workers can stay active across CPU bring
> down/up cycle.  Per-cpu kthreads need PF_THREAD_BOUND to prevent cpu
> affinity manipulation by third party for correctness. 

But that's the whole point isn't it. You mark threads that aren't
strictly per-cpu with that. Aside from the unplug trainwreck, you also
mark your unbound workers with that.

There is no correctness issue what so ever with those, and userspace
moving them about doesn't matter one whit.


