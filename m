Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2HTHK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:10:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2HTHK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:10:56 -0400
Date: Mon, 20 Aug 2012 00:10:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: aris@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 1/4] xattr: extract simple_xattr code from tmpfs
In-Reply-To: <20120816195831.GF24861@google.com>
Message-ID: <alpine.LSU.2.00.1208192356580.24824@eggly.anvils>
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174453.507922179@napanee.usersys.redhat.com> <20120816195831.GF24861@google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Tejun Heo wrote:
> On Thu, Aug 16, 2012 at 01:44:54PM -0400, aris@redhat.com wrote:
> > From: Li Zefan <lizefan@huawei.com>
> > 
> > Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.
> > 
> > $ size vmlinux.o
> >    text    data     bss     dec     hex filename
> > 4658782  880729 5195032 10734543         a3cbcf vmlinux.o
> > $ size vmlinux.o
> >    text    data     bss     dec     hex filename
> > 4658957  880729 5195032 10734718         a3cc7e vmlinux.o
> > 
> > v6:
> > - no changes
> > v5:
> > - no changes
> > v4:
> > - move simple_xattrs_free() to fs/xattr.c
> > v3:
> > - in kmem_xattrs_free(), reinitialize the list
> > - use simple_xattr_* prefix
> > - introduce simple_xattr_add() to prevent direct list usage
> > 
> > Cc: Li Zefan <lizefan@huawei.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Hugh Dickins <hughd@google.com>
> 
> Hugh, can you please review and ack this one?

Yes, it looks nice to me.  I might have preferred more as inlines in
the header file to lower the slight init/evict overhead, and I don't
see why __simple_xattr_set() isn't using simple_xattr_alloc() in the
same way that shmem_xattr_set() used shmem_xattr_alloc().  But none
of that matters:

Acked-by: Hugh Dickins <hughd@google.com>
