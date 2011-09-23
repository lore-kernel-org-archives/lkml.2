Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1IWADt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 20:03:49 -0400
Received: from peace.netnation.com ([204.174.223.2]:60869 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab1IWADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 20:03:48 -0400
Date: Thu, 22 Sep 2011 17:03:46 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] Re: 3.1-rc6: wchan not working
Message-ID: <20110923000346.GA25425@hostway.ca>
References: <20110922230647.GC503@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922230647.GC503@hostway.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:06:47PM -0700, Simon Kirby wrote:

> Without changing .config, /proc/x/wchan seems to now print "schedule" for
> everything; eg, with 0x.ca/sim/ref/3.1-rc6-blue/config-3.1.0-rc6-blue+
> as the .config. I'm currently bisecting a few other regressions as well,
> but will add this to the list, unless it's obvious to anyone...

Probably introduced by c259e01a1ec90063042f758e409cd26b2a0963c8

This patch from Peter (who should probably sign off on it) seems to work:

Tested-by: Simon Kirby <sim@hostway.ca>

diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..d249ea8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4372,7 +4372,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 

Simon-
