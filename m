Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935770Ab1JFJXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 05:23:50 -0400
Received: from shutemov.name ([188.40.19.243]:37363 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932475Ab1JFJXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 05:23:48 -0400
Date: Thu, 6 Oct 2011 12:23:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 10/10] cgroups: Add a task counter subsystem
Message-ID: <20111006092348.GB28820@shutemov.name>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <1317668832-10784-11-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317668832-10784-11-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 09:07:12PM +0200, Frederic Weisbecker wrote:
> Add a new subsystem to limit the number of running tasks,
> similar to the NR_PROC rlimit but in the scope of a cgroup.
> 
> The user can set an upper bound limit that is checked every
> time a task forks in a cgroup or is moved into a cgroup
> with that subsystem binded.
> 
> The primary goal is to protect against forkbombs that explode
> inside a container. The traditional NR_PROC rlimit is not
> efficient in that case because if we run containers in parallel
> under the same user, one of these could starve all the others
> by spawning a high number of tasks close to the user wide limit.
> 
> This is a prevention against forkbombs, so it's not deemed to
> cure the effects of a forkbomb when the system is in a state
> where it's not responsive. It's aimed at preventing from ever
> reaching that state and stop the spreading of tasks early.
> While defining the limit on the allowed number of tasks, it's
> up to the user to find the right balance between the resource
> its containers may need and what it can afford to provide.
> 
> As it's totally dissociated from the rlimit NR_PROC, both
> can be complementary: the cgroup task counter can set an upper
> bound per container and the rlmit can be an upper bound on the
> overall set of containers.
> 
> Also this subsystem can be used to kill all the tasks in a cgroup
> without races against concurrent forks, by setting the limit of
> tasks to 0, any further forks can be rejected. This is a good
> way to kill a forkbomb in a container, or simply kill any container
> without the need to retry an unbound number of times.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
