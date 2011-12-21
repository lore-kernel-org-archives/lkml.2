Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1LUTQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:16:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62251 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1LUTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:16:31 -0500
Date: Wed, 21 Dec 2011 11:16:24 -0800
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
Subject: Re: [PATCH 2/2 v3] cgroup: Drop task_lock(parent) on cgroup_fork()
Message-ID: <20111221191624.GK9213@google.com>
References: <1324494199-23928-1-git-send-email-fweisbec@gmail.com>
 <1324494199-23928-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324494199-23928-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 08:03:19PM +0100, Frederic Weisbecker wrote:
> We don't need to hold the parent task_lock() on the
> parent in cgroup_fork() because we are already synchronized
> against the two places that may change the parent css_set
> concurrently:
> 
> - cgroup_exit(), but the parent obviously can't exit concurrently
> - cgroup migration: we are synchronized against threadgroup_lock()
> 
> So we can safely remove the task_lock() there.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Containers <containers@lists.linux-foundation.org>
> Cc: Cgroups <cgroups@vger.kernel.org>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Mandeep Singh Baines <msb@chromium.org>

Applied both patches to cgroup/for-3.3 and pushed out to linux-next.

Thank you.

-- 
tejun
