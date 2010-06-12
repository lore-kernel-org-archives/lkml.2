Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0FLHTP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 03:19:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0FLHTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 03:19:13 -0400
Date: Sat, 12 Jun 2010 09:18:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Divyesh Shah <dpshah@google.com>
Cc: jaxboe@fusionio.com, peterz@infradead.org, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] Use ktime_get() instead of sched_clock() for blkio
 cgroup stats.
Message-ID: <20100612071847.GA29751@elte.hu>
References: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
 <20100612023457.14850.50439.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100612023457.14850.50439.stgit@austin.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4984]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Divyesh Shah <dpshah@google.com> wrote:

> This will take care of the pre-emptive kernel issue and the unbounded
> TSC drift problem. We will lose resolution though in some cases.

> -	blkg->stats.start_group_wait_time = sched_clock();
> +	blkg->stats.start_group_wait_time = ktime_to_ns(ktime_get());

Ugh!

ktime_get() can have insanely high overhead. Peter has added local_clock(), if 
then you should use that and apply checks to make sure the result isnt 
negative.

	Ingo
