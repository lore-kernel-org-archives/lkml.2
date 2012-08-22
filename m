Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2HVUIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:08:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab2HVUH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:07:57 -0400
Date: Wed, 22 Aug 2012 16:07:46 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
Message-ID: <20120822200746.GD16951@redhat.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174453.507922179@napanee.usersys.redhat.com>
 <20120816195831.GF24861@google.com>
 <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
 <20120820190039.GR25353@redhat.com>
 <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208202122470.1286@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 09:47:15PM -0700, Hugh Dickins wrote:
> On Mon, 20 Aug 2012, Aristeu Rozanski wrote:
> > On Mon, Aug 20, 2012 at 12:10:09AM -0700, Hugh Dickins wrote:
> > > Yes, it looks nice to me.  I might have preferred more as inlines in
> > > the header file to lower the slight init/evict overhead, and I don't
> > > see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
> > > same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
> > > of that matters:
> > > 
> > > Acked-by: Hugh Dickins <hughd@google.com>
> > 
> > I can submit additional patches to fix these. What functions you want
> > inlined?
> 
> Oh, thank you.  I was thinking that it's uncommon for tmpfs files to
> have xattrs (and the same probably true of other filesystems), so it's
> best to minimize xattrs impact on shared paths.  If simple_xattrs_init()
> and simple_xattrs_free() can be static inline functions in linux/xattr.h,
> that would be nice.

ok, done. and since Tejun is waiting for those before integrating, I'll
merge them in the original patches and resubmit everything.

> Probably more important would be to remove spin_lock() and spin_unlock()
> (and INIT_LIST_HEAD) from simple_xattrs_free() - those are unnecessary
> in shmem_evict_inode(), and wouldn't they be unnecessary whenever
> simple_xattrs_free() gets called?

Removing INIT_LIST_HEAD() it's possible by actually unlinking each xattr
inside the loop before freeing them. still, it'll have to check if the list is
empty or not, which might end up being the same?

About the locking, I'm not sure, I'm investigating it.

-- 
Aristeu

