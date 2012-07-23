Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2GWSNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:13:13 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:40548 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2GWSNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:13:10 -0400
Date: Mon, 23 Jul 2012 14:12:52 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Aristeu Rozanski <aris@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120723181252.GW14236@cathedrallabs.org>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
 <20120720175959.GA32741@cathedrallabs.org>
 <alpine.LSU.2.00.1207221136160.1896@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207221136160.1896@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 12:12:07PM -0700, Hugh Dickins wrote:
> Please, do not do this.
> 
> It may be fun to implement, but not to review and maintain.
> 
> If we're going to start supporting swappable kernel memory, tmpfs
> xattrs is not the right place to start, and libfs xattrs certainly not:
> they are a poor fit for swappable memory.  (You contemplate using whole
> pages above: that will not be very kind to those without swap.)
> 
> By all means continue Zefan's work to move xattr support from tmpfs
> to libfs (ah, to fs/xattr.c actually, okay), but keep them as kmem.
> 
> Support setting and removing user xattrs only if the user has the
> appropriate capability (which root will have): looking through the
> list of existing capabilities, CAP_IPC_LOCK actually looks appropriate,
> although I admit its name certainly does not - it's the "lock down
> unlimited amounts of memory" capability.

ok, will have to do it in cgroupfs because it allows user prefixes, not the
case on tmpfs.

> And support setting and removing user xattrs only if the filesystem
> opts in to that: so cgroupfs can opt in, everything else stay out,
> and we know where to look when memory goes missing.

hm, for tmpfs, there's a config option for it, while cgroup has a mount
option, default off.

> Will "lsattr -R" in the cgroupfs mountpoint do enough to judge how
> much memory is being used in this way?  I expect not, but I'm
> unfamliar with it: you may need to show counts elsewhere.

that's for ext{2,3,4} file attributes, not extended attributes. but agreed,
there's a need to have this stat somewhere. Tejun, any ideas?

-- 
Aristeu

