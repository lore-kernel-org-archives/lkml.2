Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2APMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:38:07 -0500
Received: from static.213.204.9.176.clients.your-server.de ([176.9.204.213]:40789
	"EHLO shutemov.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2APMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:38:05 -0500
Date: Mon, 16 Jan 2012 14:38:21 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Glauber Costa <glommer@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>, Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 8/8] cgroups: Add a task counter subsystem
Message-ID: <20120116123821.GA25918@shutemov.name>
References: <1326478441-3048-1-git-send-email-fweisbec@gmail.com>
 <1326478441-3048-17-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326478441-3048-17-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 07:14:00PM +0100, Frederic Weisbecker wrote:
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
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tim Hockin <thockin@hockin.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Containers <containers@lists.linux-foundation.org>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
