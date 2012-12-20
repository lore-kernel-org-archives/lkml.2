Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2LTFZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:25:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2LTFZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:25:44 -0500
Date: Thu, 20 Dec 2012 03:25:33 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, oleg@redhat.com, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
Message-ID: <20121220052533.GA17190@herton-Z68MA-D2H-B3>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426526-14254-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 03:28:40PM -0700, Tejun Heo wrote:
[...]
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index f8a030c..4cd1d0f 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -34,7 +34,6 @@ extern int cgroup_lock_is_held(void);
>  extern bool cgroup_lock_live_group(struct cgroup *cgrp);
>  extern void cgroup_unlock(void);
>  extern void cgroup_fork(struct task_struct *p);
> -extern void cgroup_fork_callbacks(struct task_struct *p);
>  extern void cgroup_post_fork(struct task_struct *p);
>  extern void cgroup_exit(struct task_struct *p, int run_callbacks);
>  extern int cgroupstats_build(struct cgroupstats *stats,
[...]

Minor issue, the patch missed the removal of

static inline void cgroup_fork_callbacks(struct task_struct *p) {}

for the !CONFIG_CGROUPS case

-- 
[]'s
Herton
