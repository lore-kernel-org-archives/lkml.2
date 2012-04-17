Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2DQPX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:23:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43368 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2DQPX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:23:57 -0400
Date: Tue, 17 Apr 2012 08:23:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Alexander Nikiforov <a.nikiforov@samsung.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120417152350.GC32402@google.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F86527C.2080507@samsung.com>
 <20120417010902.GA14646@somewhere.redhat.com>
 <4F8D1171.1090504@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8D1171.1090504@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 17, 2012 at 10:45:05AM +0400, Alexander Nikiforov wrote:
> between them. Now we have only 1 way to get notification about tasks
> file - inotify(), but this approach works only if you work from
> userspace with file (e.g. create struct file, for example with echo
> $$ /sys/abc/tasks), but when something happens from kernel side
> (do_fork()/do_exit) we cannot get any event about group of the
> process (we can scan tasks file and count number of PID, or work
> with
> waitpid(), but IMHO this is ugly solutions)

Wouldn't simply generating FS_MODIFY event on the tasks file do the
trick?

Thanks.

-- 
tejun
