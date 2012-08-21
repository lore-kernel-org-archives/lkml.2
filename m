Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2HUXan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 19:30:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62012 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2HUXal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 19:30:41 -0400
Date: Tue, 21 Aug 2012 16:29:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <lpoetter@redhat.com>, aris@redhat.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
In-Reply-To: <20120821214856.GC32596@google.com>
Message-ID: <alpine.LSU.2.00.1208211606580.2383@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174454.087507415@napanee.usersys.redhat.com> <20120816200006.GG24861@google.com> <50340110.50607@redhat.com> <20120821214856.GC32596@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Tejun Heo wrote:
> On Tue, Aug 21, 2012 at 11:43:44PM +0200, Lennart Poettering wrote:
> > >I'm not against this but unsure whether using kmem is enough for the
> > >suggested use case.  Lennart, would this suit systemd?  How much
> > >metadata are we talking about?
> > 
> > Just small things, like values, PIDs, i.e. a few 100 bytes or so per
> > cgroup should be more than sufficient for our needs.

That is reasonable.

> 
> Alright, then.  I think there's gonna be one more round to address
> Hugh's comments.  Hugh, how should this be routed?  Is there some git
> branch that tmpfs changes can go in so that cgroup tree can pull?

No git tree, but we can easily handle it in one of two ways.

include/linux/shmem_fs.h and mm/shmem.c usually go to Linus from Andrew
from his mmotm tree (which includes and is included in linux-next,
by some magic escaping infinite recursion).

Are we expecting Aristeu+Zefan's simple_xattr patches to go into 3.7?
I don't have anything planned for shmem.c for 3.7 beyond a bugfix,
which shouldn't interact with the simple_xattr changes at all
(I could remove info->lock, but will not do so this time around,
precisely so as not to interfere with those patches).

So it should be perfectly workable for you to take Aristeu+Zefan's
shmem patches into your cgroup tree, then any further mods from
mmotm will get layered on top.

But if you prefer to leave shmem.c changes to Andrew, then it would
also be perfectly workable for Aristeu to split the 1/4 into two:
one for you which updates fs/xattr.c and include/linux/xattr.h with
simple_xattr code stolen from mm/shmem.c and include/linux/shmem_fs.h;
and one for Andrew which updates mm/shmem.c and include/linux/shmem_fs.h
to delete its shmem_xattr stuff and use simple_xattr interfaces instead.

Either approach is fine with me.

Hugh
