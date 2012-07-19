Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2GSBMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:12:19 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61615 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GSBMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:12:16 -0400
Date: Wed, 18 Jul 2012 18:11:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
In-Reply-To: <20120718221044.GJ24336@google.com>
Message-ID: <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
References: <20120702142925.795007114@napanee.usersys.redhat.com> <20120717204126.GE24336@google.com> <alpine.LSU.2.00.1207181237010.2160@eggly.anvils> <20120718221044.GJ24336@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012, Tejun Heo wrote:
> On Wed, Jul 18, 2012 at 01:02:03PM -0700, Hugh Dickins wrote:
> > > I don't know.  I
> > > really hope it used anonymous page cache instead of kmem tho.  Hugh,
> > > would something like that be difficult?
> > 
> > Yes, it would be difficult.
> > 
> > You don't use the word "swappable", but I take that to be implicit
> > when you say "anonymous ... instead of kmem": it might as well be
> > kmem if it cannot be swapped.
> 
> Yeah, I just am not mm-savvy enough to be able to use the correct
> term. :)

No, I wasn't trying to correct you, just making that aspect explicit;
I don't often hear anyone else use the term "swappable" at all.

> 
> > So you're wondering whether to introduce a new category of swappable
> > memory: not the original anon pages mapped into userspace, not shmem
> > use of swappable pages, but xattrs in the cgroup filesystem?
> 
> But why do we need something completely new?  Can't we hijack some
> inodes used by tmpfs and use them for xattr storage?  ie. Would it be
> difficult to use tmpfs as backend storage for on-memory xattr?  With
> that, we would already have the mechanism and interface(!) for
> limiting the size.

That sounds just like what I was suggesting in my last sentence:
let userspace manage a tmpfs hierarchy parallel to the cgroupfs one.

Except, perhaps, where I assume "userspace" should be doing the hard work.

> 
> > Or am I misunderstanding, or looking at this from the wrong angle?
> > 
> > If there's not a reasonable upper bound on what gets stored here
> > (did I see the word "icon" earlier in the thread?  which made me
> > think people would be loading their photo albums into these xattrs),
> > maybe the problem does need turning around.
> > 
> > Let userspace manage a tmpfs hierarchy parallel to the cgroupfs one?
> 
> IIRC xattr for cgroupfs was suggested from systemd which currently is
> using tmpfs to manage parallel hierarchy.  It's reportedly cumbersome
> to keep in sync and they would much prefer if they can store metadata
> right inside cgroup.  If we can have a shared implementation which
> doesn't complicate each pseudo filesystem much, I think why not.

So systemd is already doing it as I suggested, but finds that awkward in
some respects, and wants more help from the kernel in synchronization.

Stuffing an unbounded amount of data into cgroupfs xattrs doesn't sound
the right way to go.

I wonder if it could be turned completely on its head, and the cgroupfs
parts be represented in xattrs on a tmpfs hierarchy?  The data contents of
the tmpfs files being entirely up to userspace i.e. systemd in ths case.

Hugh
