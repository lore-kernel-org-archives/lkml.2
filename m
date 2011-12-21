Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1LUAMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:12:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51151 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1LUAMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:12:23 -0500
Date: Tue, 20 Dec 2011 16:04:18 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 2/5] cgroup: remove redundant get/put of task struct
Message-ID: <20111221000418.GY13529@google.com>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
 <1324422873-31001-3-git-send-email-msb@chromium.org>
 <20111220232326.GL10752@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220232326.GL10752@google.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> Hello,
> 
> On Tue, Dec 20, 2011 at 03:14:30PM -0800, Mandeep Singh Baines wrote:
> > @@ -2287,14 +2280,12 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
> >  			cgroup_unlock();
> >  			return -EACCES;
> >  		}
> > -		get_task_struct(tsk);
> >  		rcu_read_unlock();
> 
> This is before threadgroup is locked.  What guarantees @tsk doesn't go
> away once rcu is unlocked?
> 

Nothing. D'oh. I'll remove the changes to attach_task_by_id and leave
the others.

> Thanks.
> 
> -- 
> tejun
