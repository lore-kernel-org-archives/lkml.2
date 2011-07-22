Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1GVAXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:23:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab1GVAXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:23:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jul 2011 09:15:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-Id: <20110722091557.f78a7a9e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110721135817.baab2a2c.akpm@linux-foundation.org>
References: <cover.1310732789.git.mhocko@suse.cz>
	<44ec61829ed8a83b55dc90a7aebffdd82fe0e102.1310732789.git.mhocko@suse.cz>
	<20110721135817.baab2a2c.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 13:58:17 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 13 Jul 2011 13:05:49 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > @@ -1893,6 +1942,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
> 
> does:
> 
> : 	memcg_wakeup_oom(mem);
> : 	mutex_unlock(&memcg_oom_mutex);
> : 
> : 	mem_cgroup_unmark_under_oom(mem);
> : 
> : 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
> : 		return false;
> : 	/* Give chance to dying process */
> : 	schedule_timeout(1);
> : 	return true;
> : }
> 
> Calling schedule_timeout() in state TASK_RUNNING is equivalent to
> calling schedule() and then pointlessly wasting some CPU cycles.
> 
Ouch (--;

> Someone might want to take a look at that, and wonder why this bug
> wasn't detected in testing ;)
> 
I wonder just removing this is okay....because we didn't noticed this
in our recent oom tests. 

I'll do some.

Thanks,
-Kame

