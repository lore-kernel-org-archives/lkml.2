Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab0HVEBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 00:01:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49652 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0HVEBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 00:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=awo91ktmS1YVZU9KRK/HqRlUgFVZK8xjGOn2Jj9rgSdS9O3EihkcpmxoWvTeAQL+5m
         UgioBuvxYDWp48Sn5TUBi3YMvPChLR5Ke9RWSKvaVKK/lO+CwiZFX748A7b2EVVvCUSR
         UIxwXjJzYOzou+mH3VKrKFOfOibR/52lkSScg=
Date: Sun, 22 Aug 2010 06:01:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        rostedt@goodmis.org
Subject: Re: [PATCH] workqueue: Add basic tracepoints to track workqueue
	execution
Message-ID: <20100822040101.GE5258@nowhere>
References: <20100821131402.577c4d75@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821131402.577c4d75@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 01:14:02PM -0700, Arjan van de Ven wrote:
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 21 Aug 2010 13:07:26 -0700
> Subject: [PATCH] workqueue: Add basic tracepoints to track workqueue execution
> 
> With the introduction of the new unified work queue thread pools,
> we lost one feature: It's no longer possible to know which worker
> is causing the CPU to wake out of idle. The result is that PowerTOP
> now reports a lot of "kworker/a:b" instead of more readable results.
> 
> This patch adds a pair of tracepoints to the new workqueue code,
> similar in style to the timer/hrtimer tracepoints.
> 
> With this pair of tracepoints, the next PowerTOP can correctly
> report which work item caused the wakeup (and how long it took):
> 
> Interrupt (43)            i915      time   3.51ms    wakeups 141
> Work      ieee80211_iface_work      time   0.81ms    wakeups  29
> Work              do_dbs_timer      time   0.55ms    wakeups  24
> Process                   Xorg      time  21.36ms    wakeups   4
> Timer    sched_rt_period_timer      time   0.01ms    wakeups   1
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



Ok, Linus applied it. That answers my doubts about the
route for this patch :)

