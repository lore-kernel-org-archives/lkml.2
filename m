Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2DMSKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:10:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46585 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2DMSKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:10:09 -0400
Message-ID: <4F886BFD.7040007@lwfinger.net>
Date: Fri, 13 Apr 2012 13:10:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: 3.4-rc2: Possible memory leak in __register_sysctl_table()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing apparent memory leaks in 3.4-rcX. I do not think I saw these in 3.3.

The kmemleak traceback is:

unreferenced object 0xffff8800b7536180 (size 96):
   comm "swapper/0", pid 1, jiffies 4294892617 (age 8756.084s)
   hex dump (first 32 bytes):
     20 c4 1c 82 ff ff ff ff 00 00 00 00 01 00 00 00   ...............
     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<ffffffff81383401>] kmemleak_alloc+0x21/0x50
     [<ffffffff81134153>] __kmalloc+0x123/0x2a0
     [<ffffffff811a8ac2>] __register_sysctl_table+0x62/0x4d0
     [<ffffffff811a907d>] register_leaf_sysctl_tables+0x14d/0x220
     [<ffffffff811a90e4>] register_leaf_sysctl_tables+0x1b4/0x220
     [<ffffffff811a92c9>] __register_sysctl_paths+0x159/0x1f0
     [<ffffffff811a9376>] register_sysctl_paths+0x16/0x20
     [<ffffffff816b5c41>] ip_static_sysctl_init+0x17/0x19
     [<ffffffff816b68bc>] inet_init+0xb4/0x2b2
     [<ffffffff810001ca>] do_one_initcall+0x3a/0x170
     [<ffffffff81686c52>] kernel_init+0xf7/0x17b
     [<ffffffff8139f154>] kernel_thread_helper+0x4/0x10
     [<ffffffffffffffff>] 0xffffffffffffffff

Thanks,

Larry
