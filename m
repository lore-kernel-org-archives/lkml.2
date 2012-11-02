Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2KBXGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:06:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KBXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:06:43 -0400
Date: Fri, 2 Nov 2012 16:06:38 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v6 00/29] kmem controller for memcg.
Message-ID: <20121102230638.GE27843@mtj.dyndns.org>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
 <20121101170454.b7713bce.akpm@linux-foundation.org>
 <50937918.7080302@parallels.com>
 <CAAmzW4O74e3J9M3Q86Y0wXX6Pfp8GDpv6jAB5ebJPHfAxAeL0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4O74e3J9M3Q86Y0wXX6Pfp8GDpv6jAB5ebJPHfAxAeL0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Joonsoo.

On Sat, Nov 03, 2012 at 04:25:59AM +0900, JoonSoo Kim wrote:
> I am worrying about data cache footprint which is possibly caused by
> this patchset, especially slab implementation.
> If there are several memcg cgroups, each cgroup has it's own kmem_caches.
> When each group do slab-intensive job hard, data cache may be overflowed easily,
> and cache miss rate will be high, therefore this would decrease system
> performance highly.

It would be nice to be able to remove such overhead too, but the
baselines for cgroup implementations (well, at least the ones that I
think important) in somewhat decreasing priority are...

1. Don't over-complicate the target subsystem.

2. Overhead when cgroup is not used should be minimal.  Prefereably to
   the level of being unnoticeable.

3. Overhead while cgroup is being actively used should be reasonable.

If you wanna split your system into N groups and maintain memory
resource segregation among them, I don't think it's unreasonable to
ask for paying data cache footprint overhead.

So, while improvements would be nice, I wouldn't consider overheads of
this type as a blocker.

Thanks.

-- 
tejun
