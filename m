Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab0FDE7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:59:17 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39710 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FDE7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:59:15 -0400
Message-ID: <4C08881F.7020407@in.ibm.com>
Date: Fri, 04 Jun 2010 10:29:11 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [-next Jun 3] s390 : Bug - Bad page state while running hackbench
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While executing hackbench against yesterday's next (20100603) came across
this following BUG

EXT3-fs (dasdb1): mounted filesystem with writeback data mode
BUG: Bad page state in process hackbench  pfn:de2db
page:000003e003099fe8 count:0 mapcount:0 mapping:0000000100000000 index:0x0
page flags: 0x4000000000000000()
CPU: 2 Not tainted 2.6.35-rc1-autotest-next-20100603-5-default #1
Process hackbench (pid: 2151, task: 00000000fa6dc538, ksp: 00000000fac43e10)
0000000000000000 00000000fac43988 0000000000000002 0000000000000000
       00000000fac43a28 00000000fac439a0 00000000fac439a0 0000000000459f2a
       0000000000000001 000003e003099fe8 0000000000000002 0000000000000000
       000000000000000d 0000000000000000 00000000fac439f0 000000000000000e
       000000000047a0c8 0000000000105f80 00000000fac43988 00000000fac439d0
Call Trace:
(<0000000000105e8a> show_trace+0xe6/0x134)
 <00000000001e2bb6> bad_page+0xc6/0x154
 <00000000001e5268> get_page_from_freelist+0x450/0x6dc
 <00000000001e582e> __alloc_pages_nodemask+0x126/0x6f8
 <0000000000104b46> crst_table_alloc+0x42/0x14c
 <000000000013fe12> mm_init+0x12a/0x198
 <0000000000140268> dup_mm+0xac/0x6dc
 <00000000001411d2> copy_process+0x88e/0x10c0
 <0000000000141a96> do_fork+0x92/0x3b8
 <000000000010b2e2> SyS_clone+0x5e/0x6c
 <000000000011962e> sysc_noemu+0x10/0x16
 <0000020000126b8e> 0x20000126b8e
Disabling lock debugging due to kernel taint
Jun  3 18:44:23 lnxabat6 kernel: CPU: 2 Not tainted 2.6.35-rc1-autotest-next-20100603-5-default #1
Jun  3 18:44:23 lnxabat6 kernel: Process hackbench (pid: 2151, task:00000000fa6dc538, ksp: 00000000fac43e10)
Jun  3 18:44:23 lnxabat6 kernel: 0000000000000000 00000000fac439880000000000000002 0000000000000000
Jun  3 18:44:23 lnxabat6 kernel:        00000000fac43a28 00000000fac439a0 00000000fac439a0 0000000000459f2a
Jun  3 18:44:23 lnxabat6 kernel:        0000000000000001 000003e003099fe8 0000000000000002 0000000000000000
Jun  3 18:44:23 lnxabat6 kernel:        000000000000000d 0000000000000000 00000000fac439f0 000000000000000e
Jun  3 18:44:23 lnxabat6 kernel:        000000000047a0c8 0000000000105f80 00000000fac43988 00000000fac439d0
Jun  3 18:44:23 lnxabat6 kernel: Call Trace:
Jun  3 18:44:23 lnxabat6 kernel: (<0000000000105e8a> show_trace+0xe6/0x134)
Jun  3 18:44:23 lnxabat6 kernel:  <00000000001e5268> get_page_from_freelist+0x450/0x6dc
Jun  3 18:44:23 lnxabat6 kernel:  <00000000001e582e> __alloc_pages_nodemask+0x126/0x6f8
Jun  3 18:44:23 lnxabat6 kernel:  <0000000000104b46> crst_table_alloc+0x42/0x14c
Jun  3 18:44:23 lnxabat6 kernel:  <000000000013fe12> mm_init+0x12a/0x198
Jun  3 18:44:23 lnxabat6 kernel:  <0000000000140268> dup_mm+0xac/0x6dc
Jun  3 18:44:23 lnxabat6 kernel:  <00000000001411d2> copy_process+0x88e/0x10c0
Jun  3 18:44:23 lnxabat6 kernel:  <0000000000141a96> do_fork+0x92/0x3b8
Jun  3 18:44:23 lnxabat6 kernel:  <000000000010b2e2> SyS_clone+0x5e/0x6c
Jun  3 18:44:23 lnxabat6 kernel:  <000000000011962e> sysc_noemu+0x10/0x16
Jun  3 18:44:23 lnxabat6 kernel:  <0000020000126b8e> 0x20000126b8e

next-20100602 was good. 

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

