Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab1LWXAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 18:00:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50250 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab1LWXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 18:00:19 -0500
Date: Fri, 23 Dec 2011 15:00:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] cgroup: Remove task_lock() from cgroup_post_fork()
Message-ID: <20111223230013.GV17084@google.com>
References: <1324610723-30080-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324610723-30080-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 04:25:23AM +0100, Frederic Weisbecker wrote:
> cgroup_post_fork() is protected between threadgroup_change_begin()
> and threadgroup_change_end() against concurrent changes of the
> child's css_set in cgroup_task_migrate(). Also the child can't
> exit and call cgroup_exit() at this stage, this means it's css_set
> can't be changed with init_css_set concurrently.
> 
> For these reasons, we don't need to hold task_lock() on the child
> because it's css_set can only remain stable in this place.
> 
> Let's remove the lock there.
> 
> v2: Update comment to explain that we are safe against
> cgroup_exit()
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>

Li, does this look good to you?

Thanks.

-- 
tejun
