Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2HWXPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:15:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36013 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab2HWXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:15:09 -0400
Date: Thu, 23 Aug 2012 16:14:24 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: aris@redhat.com
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v7 1/4] xattr: extract simple_xattr code from tmpfs
In-Reply-To: <20120823205327.613311683@napanee.usersys.redhat.com>
Message-ID: <alpine.LSU.2.00.1208231609240.5904@eggly.anvils>
References: <20120823205327.237533518@napanee.usersys.redhat.com> <20120823205327.613311683@napanee.usersys.redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012, aris@redhat.com wrote:
> From: Li Zefan <lizefan@huawei.com>
> 
> Extract in-memory xattr APIs from tmpfs. Will be used by cgroup.
> 
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658782  880729 5195032 10734543         a3cbcf vmlinux.o
> $ size vmlinux.o
>    text    data     bss     dec     hex filename
> 4658957  880729 5195032 10734718         a3cc7e vmlinux.o
> 
> v7:
> - checkpatch warnings fixed
> - Implement the changes requested by Hugh Dickins:
> 	- make simple_xattrs_init and simple_xattrs_free inline
> 	- get rid of locking and list reinitialization in simple_xattrs_free,
> 	  they're not needed

Thanks for doing those.

I'm also happy to see that you're now using simple_xattr_alloc() in
__simple_xattr_set() (but no need to respin to comment on that here).

It looks very nice: much better for this code to live in fs/xattr.c
than in mm/shmem.c.

> v6:
> - no changes
> v5:
> - no changes
> v4:
> - move simple_xattrs_free() to fs/xattr.c
> v3:
> - in kmem_xattrs_free(), reinitialize the list
> - use simple_xattr_* prefix
> - introduce simple_xattr_add() to prevent direct list usage
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

> Cc: Hillf Danton <dhillf@gmail.com>
> Cc: Lennart Poettering <lpoetter@redhat.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
