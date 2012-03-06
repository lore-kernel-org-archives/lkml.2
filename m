Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab2CFViO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:38:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63102 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab2CFViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:38:12 -0500
Date: Tue, 6 Mar 2012 13:37:36 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Miklos Szeredi <mszeredi@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
In-Reply-To: <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
Message-ID: <alpine.LSU.2.00.1203061314400.17934@eggly.anvils>
References: <4F4F1459.4080300@cn.fujitsu.com> <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Tejun Heo wrote:
> On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
> > This can be used to attach metadata to a cgroup, which is required
> > by systemd.

I've not reviewed your patches in detail, but I'm very happy for most
of the shmem xattr code to move out to a library for use elsewhere.

Note that the linux-next mm/shmem.c now includes Jarkko Sakkinen's
shmem_initxattrs() work, maybe you can draw from that too.

> > 
> > As lazy as I am, here just quoted from Lennart for the detailed use
> > cases:
> 
> I much prefer this version but would prefer to deal with this in the
> next merge window as we're already on rc6.  On a cursory look...
> 
> * I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
>   stored in kmem w/o size limit and we probably want to improve on
>   both fronts in the future.  Wouldn't it be better to name them
>   simple_*() and put them in fs/libfs.c?

Yes, simple_*() in fs/libfs.c sounds much better to me than kmem_*().

On the size limit issue, shmem has its own shmem_xattr_validate(),
which rejects XATTR_USER_PREFIX, and the patches leave that unchanged.

I don't know whether the cgroup xattrs need to support USER or not,
and I don't know what permissions would be involved if they do;
but it's an important concern.

Hugh

> 
> * I don't think we want CONFIG option for cgroupfs xattr.  Let's just
>   add a mount option.
