Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934404Ab2HWUxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:53:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934288Ab2HWUxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:53:33 -0400
Message-Id: <20120823205327.237533518@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Thu, 23 Aug 2012 16:53:27 -0400
From: aris@redhat.com
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: [PATCH v7 0/4] cgroup: add xattr support 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series are a refreshed version of a patchset submitted by Li Zefan back
in march:
	https://lkml.org/lkml/2012/3/1/13

With Li's permission, I refreshed the patches to apply over the latest upstream
and added the modifications suggested by others in the thread:
- using a mount option instead of config option to enable the xattr support
- reinitialize the list in kmem_xattrs_free()
- renamed functions to simple_xattr_*()

There're two users for this patchset:
- SELinux: to be able to control access to cgroupfs inside containers
- systemd: to store meta information such as main PID in a service cgroup,
  set specific services special options in the cgroup.

While the xattrs will use kernel memory like tmpfs, they're restricted to
'security' (which controls the format of the value) and 'trusted' (which
requires CAP_SYS_ADMIN). If kernel memory usage is still a concern, we're
not far from having memcg account for kernel memory.

v7:
- fix checkpatch.pl warnings
- Implement the changes requested by Hugh Dickins:
        - make simple_xattrs_init and simple_xattrs_free inline
        - get rid of locking and list reinitialization in simple_xattrs_free,
          they're not needed
v6:
- only allow trusted and security
- replace subsys_bits by something more meaningful
v5:
- check for permissions for user xattr namespace
v4:
- implemented requested changes by Tejun Heo in patch #2

Cc: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Lennart Poettering <lpoetter@redhat.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu
