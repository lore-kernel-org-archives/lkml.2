Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab2GQUlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:41:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2GQUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:41:31 -0400
Date: Tue, 17 Jul 2012 13:41:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120717204126.GE24336@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120702142925.795007114@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 02, 2012 at 10:29:25AM -0400, Aristeu Rozanski wrote:
> This series are a refreshed version of a patchset submitted by Li Zefan back
> in march:
> 	https://lkml.org/lkml/2012/3/1/13
> 
> With Li's permission, I refreshed the patches to apply over the latest upstream
> and added the modifications suggested by others in the thread:
> - using a mount option instead of config option to enable the xattr support
> - reinitialize the list in kmem_xattrs_free()
> - renamed functions to simple_xattr_*()
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

I raised this point before but I'm worried about directly exposing
kernel memory through xattr interface to userland.  Maybe it's okay as
long as !root users are kept from creating them.  I don't know.  I
really hope it used anonymous page cache instead of kmem tho.  Hugh,
would something like that be difficult?

Thanks.

-- 
tejun
