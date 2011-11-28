Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1K1RP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:15:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1K1RP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:15:28 -0500
Date: Mon, 28 Nov 2011 12:14:45 -0500
From: Jason Baron <jbaron@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        mingo@elte.hu, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perf, core: rate limit perf_sched_events jump_label
 patching
Message-ID: <20111128171445.GA2519@redhat.com>
References: <20111127155909.GO2557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111127155909.GO2557@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 05:59:09PM +0200, Gleb Natapov wrote:
> jump_lable patching is very expensive operation that involves pausing all
> cpus. The patching of perf_sched_events jump_label is easily controllable
> from userspace by unprivileged user. When user runs loop like this
> "while true; do perf stat -e cycles true; done" the performance of my
> test application that just increments a counter for one second drops by
> 4%. This is on a 16 cpu box with my test application using only one of
> them. An impact on a real server doing real work will be much worse.
> Performance of KVM PMU drops nearly 50% due to jump_lable for "perf
> record" since KVM PMU implementation creates and destroys perf event
> frequently.
> 
> This patch introduce the way to rate limit jump_label patching and uses
> it to fix above problem. I believe that as jump_label use will spread
> the problem will become more common and thus solving it in a generic
> code is appropriate. Also fixing it in a perf code will result in moving
> jump_label accounting logic to perf code with all the ifdefs in case
> of JUMP_LABEL=n kernel. With this patch all details are nicely hidden
> inside jump_label code.
> 

Looks good to me.

Acked-by: Jason Baron <jbaron@redhat.com>

Thanks,

-Jason
