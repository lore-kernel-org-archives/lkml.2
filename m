Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2GRWKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:10:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59702 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab2GRWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:10:49 -0400
Date: Wed, 18 Jul 2012 15:10:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120718221044.GJ24336@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Wed, Jul 18, 2012 at 01:02:03PM -0700, Hugh Dickins wrote:
> > I don't know.  I
> > really hope it used anonymous page cache instead of kmem tho.  Hugh,
> > would something like that be difficult?
> 
> Yes, it would be difficult.
> 
> You don't use the word "swappable", but I take that to be implicit
> when you say "anonymous ... instead of kmem": it might as well be
> kmem if it cannot be swapped.

Yeah, I just am not mm-savvy enough to be able to use the correct
term. :)

> So you're wondering whether to introduce a new category of swappable
> memory: not the original anon pages mapped into userspace, not shmem
> use of swappable pages, but xattrs in the cgroup filesystem?

But why do we need something completely new?  Can't we hijack some
inodes used by tmpfs and use them for xattr storage?  ie. Would it be
difficult to use tmpfs as backend storage for on-memory xattr?  With
that, we would already have the mechanism and interface(!) for
limiting the size.

> Or am I misunderstanding, or looking at this from the wrong angle?
> 
> If there's not a reasonable upper bound on what gets stored here
> (did I see the word "icon" earlier in the thread?  which made me
> think people would be loading their photo albums into these xattrs),
> maybe the problem does need turning around.
> 
> Let userspace manage a tmpfs hierarchy parallel to the cgroupfs one?

IIRC xattr for cgroupfs was suggested from systemd which currently is
using tmpfs to manage parallel hierarchy.  It's reportedly cumbersome
to keep in sync and they would much prefer if they can store metadata
right inside cgroup.  If we can have a shared implementation which
doesn't complicate each pseudo filesystem much, I think why not.

Thanks.

-- 
tejun
