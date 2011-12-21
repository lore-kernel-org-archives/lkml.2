Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1LUBIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:08:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1LUBIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:08:37 -0500
Message-ID: <4EF13215.905@cn.fujitsu.com>
Date: Wed, 21 Dec 2011 09:10:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 1/5 V3] cgroup: remove redundate get/put of old css_set
 from migrate
References: <1324422873-31001-1-git-send-email-msb@chromium.org> <1324422873-31001-2-git-send-email-msb@chromium.org>
In-Reply-To: <1324422873-31001-2-git-send-email-msb@chromium.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:07:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-21 09:07:54,
	Serialize complete at 2011-12-21 09:07:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> Changes in V3:
> * Fixed to put error in retval (thanks Frederic Weisbecker)
>   * https://lkml.org/lkml/2011/12/20/255
> Changes in V2:
> * Updated commit message as per Tejun's feedback:
>   * https://lkml.org/lkml/2011/12/19/289
> 
> -- >8 -- (snip)
> 
> We can now assume that the css_set reference held by the task
> will not go away for an exiting task. PF_EXITING state can be
> trusted throughout migration by checking it after locking
> threadgroup.
> 
> While at it, renamed css_set_check_fetched to css_set_fetched.
> !css_set_fetched() seems to read better than
> !css_set_check_fetched().
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: containers@lists.linux-foundation.org
> Cc: cgroups@vger.kernel.org
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> ---
>  kernel/cgroup.c |   25 ++++++-------------------
>  1 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index bc3caff..4166066 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1856,7 +1856,6 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	 */
>  	task_lock(tsk);

The comments above this line of code should be updated accordingly.

>  	oldcg = tsk->cgroups;
> -	get_css_set(oldcg);
>  	task_unlock(tsk);
>  
>  	/* locate or allocate a new css_set for this task. */
