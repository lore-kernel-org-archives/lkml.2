Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab2J2WA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:00:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab2J2WAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:00:24 -0400
Date: Mon, 29 Oct 2012 15:00:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v3 3/6] memcg: Simplify mem_cgroup_force_empty_list
 error handling
Message-Id: <20121029150022.a595b866.akpm@linux-foundation.org>
In-Reply-To: <508E8B95.406@parallels.com>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz>
	<1351251453-6140-4-git-send-email-mhocko@suse.cz>
	<508E8B95.406@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012 17:58:45 +0400
Glauber Costa <glommer@parallels.com> wrote:

> > + * move charges to its parent or the root cgroup if the group has no
> > + * parent (aka use_hierarchy==0).
> > + * Although this might fail (get_page_unless_zero, isolate_lru_page or
> > + * mem_cgroup_move_account fails) the failure is always temporary and
> > + * it signals a race with a page removal/uncharge or migration. In the
> > + * first case the page is on the way out and it will vanish from the LRU
> > + * on the next attempt and the call should be retried later.
> > + * Isolation from the LRU fails only if page has been isolated from
> > + * the LRU since we looked at it and that usually means either global
> > + * reclaim or migration going on. The page will either get back to the
> > + * LRU or vanish.
> 
> I just wonder for how long can it go in the worst case?

If the kernel is uniprocessor and the caller is SCHED_FIFO: ad infinitum!
