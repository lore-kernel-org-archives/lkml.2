Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab1I3Jag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:30:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267Ab1I3Jaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:30:35 -0400
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 11:29:57 +0200
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
	 <1317355529.4588.45.camel@gandalf.stny.rr.com>
	 <20110930041424.GH10425@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317374997.19415.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 10:34 +0200, Peter Zijlstra wrote:
> Introduce a new WQ_NON_AFFINE flag that indicates a per-cpu workqueue
> will not respect cpu affinity and use this to migrate all its pending
> works to whatever cpu is doing cpu-down. 

Forgot to mention, it will also dis-allow queue_work_on() usage for
these workqueues, since that API implies you actually care what cpu the
work runs on, which cannot be guaranteed.
