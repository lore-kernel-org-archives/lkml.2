Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2F0Dtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 23:49:41 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56733 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2F0Dtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 23:49:40 -0400
Date: Tue, 26 Jun 2012 23:49:15 -0400 (EDT)
From: Zhouping Liu <zliu@redhat.com>
To: linux-mm@kvack.org
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.66.12.116]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, all

when I used memory cgroup in latest mainline, the following error occurred:

# mount -t cgroup -o memory xxx /cgroup/
# ll /cgroup/memory.memsw.*
-rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.failcnt
-rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.limit_in_bytes
-rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.max_usage_in_bytes
-r--r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.usage_in_bytes
# cat /cgroup/memory.memsw.*
cat: /cgroup/memory.memsw.failcnt: Operation not supported
cat: /cgroup/memory.memsw.limit_in_bytes: Operation not supported
cat: /cgroup/memory.memsw.max_usage_in_bytes: Operation not supported
cat: /cgroup/memory.memsw.usage_in_bytes: Operation not supported

I'm confusing why it can't read memory.memsw.* files.

as commit:a42c390cfa0c said, CGROUP_MEM_RES_CTLR_SWAP_ENABLED and
swapaccount kernel parameter control memcg swap accounting,
but I confirmed the two options all don't be set:

# cat /usr/lib/modules/3.5.0-rc4+/source/.config | grep CGROUP_MEM
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED is not set
CONFIG_CGROUP_MEM_RES_CTLR_KMEM=y
# cat /proc/cmdline 
BOOT_IMAGE=/vmlinuz-3.5.0-rc4+ root=/dev/mapper/vg_amd--pike--06-lv_root ro rd.lvm.lv=vg_amd-pike-06/lv_swap rd.md=0 LANG=en_US.UTF-8 console=ttyS0,115200n81 KEYTABLE=us SYSFONT=True rd.luks=0 rd.dm=0 rd.lvm.lv=vg_amd-pike-06/lv_root

so I have two problems here:
 1. when kernel neither set 'CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED' nor 'swapaccount' options,
    why memcg have memory.memsw.* files ?

 2. why we can't read memory.memsw.* ?

Addition info:
when I open CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED option, the above issues are gone.
also I tested v3.4.0, there aren't the two issues, so please take a look.

-- 
Thanks,
Zhouping
