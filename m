Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0GIJpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:45:11 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39442 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab0GIJpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:45:08 -0400
Message-ID: <4C36EF9C.7010804@in.ibm.com>
Date: Fri, 09 Jul 2010 15:15:00 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-s390@vger.kernel.org
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [-next July 9 - s390 ] Badness at fs/sysfs/symlink.c:82 during qeth
 initalization
References: <20100709150117.51612026.sfr@canb.auug.org.au>
In-Reply-To: <20100709150117.51612026.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With today's next(20100709) qeth interface fails to initialize
with following Badness message:

sysfs: symlink across ns_types 0.0.6000/net:eth0 -> net/eth0
------------ cut here ------------
Badness at fs/sysfs/symlink.c:82
Modules linked in: qeth_l3 ipv6 qeth qdio vmur ccwgroup scsi_dh_alua scsi_dh_rda
c scsi_dh_hp_sw scsi_dh_emc dm_zero ext3 mbcache multipath jbd dm_snapshot dm_mi
rror dm_region_hash dm_log dm_round_robin dm_multipath dm_mod scsi_dh sd_mod scs
i_mod crc_t10dif dasd_fba_mod dasd_eckd_mod dasd_mod
CPU: 0 Tainted: G        W   2.6.35-rc4-autotest-next-20100709-5-default #1
Process udevd (pid: 587, task: 00000000fcdc0038, ksp: 00000000faa4f9a8)
Krnl PSW : 0704000180000000 00000000002ac5b0 (sysfs_do_create_link+0x120/0x268)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000010000 0000000000719408 0000000000000043 00000000ffffffff
           000000000045bf5a 0000000000000000 00000000fa96b640 0000000000000001
           0000000000000001 00000000faa4fbb0 00000000fca76500 00000000fb139a50
           0000000000000000 000000000048be60 00000000002ac5ac 00000000faa4fb10
Krnl Code: 00000000002ac5a0: c020001545ad       larl    %r2,5550fa
           00000000002ac5a6: c0e5000d7cb1       brasl   %r14,45bf08
           00000000002ac5ac: a7f40001           brc     15,2ac5ae
          >00000000002ac5b0: b9040029           lgr     %r2,%r9
           00000000002ac5b4: a7c8ffea           lhi     %r12,-22
           00000000002ac5b8: c0e5fffffbf8       brasl   %r14,2abda8
           00000000002ac5c2: 5830b000           l       %r3,0(%r11)
Call Trace:
(<00000000002ac5ac> sysfs_do_create_link+0x11c/0x268)
 <0000000000358f62> device_add+0x6c2/0x734
 <00000000003cffa8> netdev_register_kobject+0x88/0x188
 <00000000003be7aa> register_netdevice+0x236/0x450
 <00000000003bea1e> register_netdev+0x5a/0x74
 <000003c00633a5b8> __qeth_l3_set_online+0x9d8/0x1518 qeth_l3
 <000003c004cb4ada> ccwgroup_online_store+0x1e6/0x230 ccwgroup
 <00000000002a9e10> sysfs_write_file+0xec/0x19c
 <00000000002301d0> vfs_write+0xac/0x184
 <000000000023039e> SyS_write+0x52/0xa8
 <00000000001195ee> sysc_noemu+0x10/0x16
 <0000020000151444> 0x20000151444
Last Breaking-Event-Address:
 <00000000002ac5ac> sysfs_do_create_link+0x11c/0x268

Yesterday's next was good.

Last commit that changed symlink.c was

commit d7866652cda316006089fa42b931627992c08010
sysfs: Don't allow the creation of symlinks we can't remove

This commit added the above WARN() message. I haven't tried to revert
this commit to check if that helps with qeth initialization.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

