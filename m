Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1KDJJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:09:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51288 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1KDJJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:09:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 18:08:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] cgroup: don't use subsys->can_attach_task() or
 ->attach_task()
Message-Id: <20111104180846.36f0a00e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1320191193-8110-9-git-send-email-tj@kernel.org>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
	<1320191193-8110-9-git-send-email-tj@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Nov 2011 16:46:31 -0700
Tejun Heo <tj@kernel.org> wrote:

> Now that subsys->can_attach() and attach() take @tset instead of
> @task, they can handle per-task operations.  Convert
> ->can_attach_task() and ->attach_task() users to use ->can_attach()
> and attach() instead.  Most converions are straight-forward.
> Noteworthy changes are,
> 
> * In cgroup_freezer, remove unnecessary NULL assignments to unused
>   methods.  It's useless and very prone to get out of sync, which
>   already happened.
> 
> * In cpuset, PF_THREAD_BOUND test is checked for each task.  This
>   doesn't make any practical difference but is conceptually cleaner.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <peterz@infradead.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

