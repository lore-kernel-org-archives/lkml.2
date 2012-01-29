Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab2A2Uh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 15:37:56 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61565 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2A2Uhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 15:37:55 -0500
Date: Sun, 29 Jan 2012 12:37:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20120129203749.GE17211@htj.dyndns.org>
References: <1327429591-8507-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327429591-8507-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Manddep.

On Tue, Jan 24, 2012 at 10:26:31AM -0800, Mandeep Singh Baines wrote:
> In cgroup_attach_proc, we indirectly call find_existing_css_set 3
> times. It is an expensive call so we want to call it a minimum
> of times. This patch only calls it once and stores the result so
> that it can be used later on when we call cgroup_task_migrate.
> 
> This required modifying cgroup_task_migrate to take the new css_set
> (which we obtained from find_css_set) as a parameter. The nice side
> effect of this is that cgroup_task_migrate is now identical for
> cgroup_attach_task and cgroup_attach_proc. It also now returns a
> void since it can never fail.
> 
> Changes in V5:
> * https://lkml.org/lkml/2012/1/20/344 (Tejun Heo)
>   * Remove css_set_refs
             ^^^^^^^^^^^^
>  static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
>  {
> -	int retval, i, group_size;
> +	int retval, i, group_size, css_set_refs = 0;
				   ^^^^^^^^^^^^
Wrong patch?

Thanks.

-- 
tejun
