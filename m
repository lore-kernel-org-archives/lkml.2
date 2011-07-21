Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1GUU6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:58:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191Ab1GUU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:58:30 -0400
Date: Thu, 21 Jul 2011 13:58:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] memcg: make oom_lock 0 and 1 based rather than
 coutner
Message-Id: <20110721135817.baab2a2c.akpm@linux-foundation.org>
In-Reply-To: <44ec61829ed8a83b55dc90a7aebffdd82fe0e102.1310732789.git.mhocko@suse.cz>
References: <cover.1310732789.git.mhocko@suse.cz>
	<44ec61829ed8a83b55dc90a7aebffdd82fe0e102.1310732789.git.mhocko@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 13:05:49 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> @@ -1893,6 +1942,8 @@ bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)

does:

: 	memcg_wakeup_oom(mem);
: 	mutex_unlock(&memcg_oom_mutex);
: 
: 	mem_cgroup_unmark_under_oom(mem);
: 
: 	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
: 		return false;
: 	/* Give chance to dying process */
: 	schedule_timeout(1);
: 	return true;
: }

Calling schedule_timeout() in state TASK_RUNNING is equivalent to
calling schedule() and then pointlessly wasting some CPU cycles.

Someone might want to take a look at that, and wonder why this bug
wasn't detected in testing ;)

