Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0JNGgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:36:10 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:35201 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752400Ab0JNGgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:36:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Oct 2010 02:36:08 EDT
Message-ID: <20101014062928.31661.qmail@info88.gawab.com>
From: "Justin Madru" <jdm64@gawab.com>
To: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: [2.6.32] dpkg blocked for more than 120 seconds when moving large files
Date: Thu, 14 Oct 2010 06:29:28 GMT
Content-Type: text/plain ; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.127.251.116]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was moving 26GB from one disk to another while dpkg was installing
packages. While transferring, dpkg completely froze. I got the following
kernel messages explaining that the process was blocked for more than 120
seconds. Once the transfer finished dpkg resumed. I'm running 64bit kernel
version 2.6.32 (debian 2.6.32-5-amd64 version 2.6.32-23).

Is this a bug? If not, why is the scheduler not being fair?

[6859080.516111] INFO: task dpkg:3254 blocked for more than 120 seconds.
[6859080.516141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6859080.516176] dpkg          D ffff88000180f9f0     0  3254   3085
0x00000000
[6859080.516187]  ffff8800792e0710 0000000000000086 ffff88003bb9fdb8
ffff88003bb9fdb4
[6859080.516197]  0000000000000000 0000000000000000 000000000000f8a0
ffff88003bb9ffd8
[6859080.516205]  0000000000015640 0000000000015640 ffff88003774d4c0
ffff88003774d7b8
[6859080.516214] Call Trace:
[6859080.516234]  [<ffffffff810b3516>] ? find_get_pages_tag+0x46/0xdd
[6859080.516246]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859080.516254]  [<ffffffff81107454>] ? bdi_sched_wait+0x9/0xe
[6859080.516263]  [<ffffffff812f9a56>] ? __wait_on_bit+0x41/0x70
[6859080.516271]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859080.516278]  [<ffffffff812f9af0>] ? out_of_line_wait_on_bit+0x6b/0x77
[6859080.516287]  [<ffffffff81064b28>] ? wake_bit_function+0x0/0x23
[6859080.516296]  [<ffffffff811074cc>] ? sync_inodes_sb+0x73/0x12a
[6859080.516304]  [<ffffffff8110b051>] ? __sync_filesystem+0x4b/0x70
[6859080.516311]  [<ffffffff8110b110>] ? sync_filesystems+0x9a/0xe3
[6859080.516317]  [<ffffffff8110b19e>] ? sys_sync+0x1c/0x2e
[6859080.516329]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[6859320.516161] INFO: task dpkg:3408 blocked for more than 120 seconds.
[6859320.516192] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6859320.516227] dpkg          D 0000000000000002     0  3408   3085
0x00000000
[6859320.516237]  ffffffff8145b1f0 0000000000000082 0000000771257db8
ffff880071257e60
[6859320.516247]  0000000000000000 0000000000000000 000000000000f8a0
ffff880071257fd8
[6859320.516255]  0000000000015640 0000000000015640 ffff8800792e1530
ffff8800792e1828
[6859320.516263] Call Trace:
[6859320.516282]  [<ffffffff810b3516>] ? find_get_pages_tag+0x46/0xdd
[6859320.516294]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859320.516302]  [<ffffffff81107454>] ? bdi_sched_wait+0x9/0xe
[6859320.516311]  [<ffffffff812f9a56>] ? __wait_on_bit+0x41/0x70
[6859320.516319]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859320.516326]  [<ffffffff812f9af0>] ? out_of_line_wait_on_bit+0x6b/0x77
[6859320.516335]  [<ffffffff81064b28>] ? wake_bit_function+0x0/0x23
[6859320.516343]  [<ffffffff811074cc>] ? sync_inodes_sb+0x73/0x12a
[6859320.516352]  [<ffffffff8110b051>] ? __sync_filesystem+0x4b/0x70
[6859320.516358]  [<ffffffff8110b110>] ? sync_filesystems+0x9a/0xe3
[6859320.516365]  [<ffffffff8110b19e>] ? sys_sync+0x1c/0x2e
[6859320.516376]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[6859440.516087] INFO: task dpkg:3408 blocked for more than 120 seconds.
[6859440.516116] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6859440.516151] dpkg          D 0000000000000002     0  3408   3085
0x00000000
[6859440.516161]  ffffffff8145b1f0 0000000000000082 0000000771257db8
ffff880071257e60
[6859440.516171]  0000000000000000 0000000000000000 000000000000f8a0
ffff880071257fd8
[6859440.516180]  0000000000015640 0000000000015640 ffff8800792e1530
ffff8800792e1828
[6859440.516188] Call Trace:
[6859440.516207]  [<ffffffff810b3516>] ? find_get_pages_tag+0x46/0xdd
[6859440.516218]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859440.516226]  [<ffffffff81107454>] ? bdi_sched_wait+0x9/0xe
[6859440.516236]  [<ffffffff812f9a56>] ? __wait_on_bit+0x41/0x70
[6859440.516244]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859440.516251]  [<ffffffff812f9af0>] ? out_of_line_wait_on_bit+0x6b/0x77
[6859440.516260]  [<ffffffff81064b28>] ? wake_bit_function+0x0/0x23
[6859440.516268]  [<ffffffff811074cc>] ? sync_inodes_sb+0x73/0x12a
[6859440.516276]  [<ffffffff8110b051>] ? __sync_filesystem+0x4b/0x70
[6859440.516283]  [<ffffffff8110b110>] ? sync_filesystems+0x9a/0xe3
[6859440.516290]  [<ffffffff8110b19e>] ? sys_sync+0x1c/0x2e
[6859440.516300]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[6859560.516078] INFO: task dpkg:3408 blocked for more than 120 seconds.
[6859560.516108] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6859560.516143] dpkg          D 0000000000000002     0  3408   3085
0x00000000
[6859560.516154]  ffffffff8145b1f0 0000000000000082 0000000771257db8
ffff880071257e60
[6859560.516164]  0000000000000000 0000000000000000 000000000000f8a0
ffff880071257fd8
[6859560.516172]  0000000000015640 0000000000015640 ffff8800792e1530
ffff8800792e1828
[6859560.516180] Call Trace:
[6859560.516200]  [<ffffffff810b3516>] ? find_get_pages_tag+0x46/0xdd
[6859560.516212]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859560.516220]  [<ffffffff81107454>] ? bdi_sched_wait+0x9/0xe
[6859560.516230]  [<ffffffff812f9a56>] ? __wait_on_bit+0x41/0x70
[6859560.516237]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859560.516245]  [<ffffffff812f9af0>] ? out_of_line_wait_on_bit+0x6b/0x77
[6859560.516254]  [<ffffffff81064b28>] ? wake_bit_function+0x0/0x23
[6859560.516262]  [<ffffffff811074cc>] ? sync_inodes_sb+0x73/0x12a
[6859560.516270]  [<ffffffff8110b051>] ? __sync_filesystem+0x4b/0x70
[6859560.516277]  [<ffffffff8110b110>] ? sync_filesystems+0x9a/0xe3
[6859560.516284]  [<ffffffff8110b19e>] ? sys_sync+0x1c/0x2e
[6859560.516295]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b
[6859680.520072] INFO: task dpkg:3408 blocked for more than 120 seconds.
[6859680.520102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[6859680.520137] dpkg          D 0000000000000002     0  3408   3085
0x00000000
[6859680.520148]  ffffffff8145b1f0 0000000000000082 0000000771257db8
ffff880071257e60
[6859680.520158]  0000000000000000 0000000000000000 000000000000f8a0
ffff880071257fd8
[6859680.520166]  0000000000015640 0000000000015640 ffff8800792e1530
ffff8800792e1828
[6859680.520175] Call Trace:
[6859680.520195]  [<ffffffff810b3516>] ? find_get_pages_tag+0x46/0xdd
[6859680.520207]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859680.520215]  [<ffffffff81107454>] ? bdi_sched_wait+0x9/0xe
[6859680.520225]  [<ffffffff812f9a56>] ? __wait_on_bit+0x41/0x70
[6859680.520233]  [<ffffffff8110744b>] ? bdi_sched_wait+0x0/0xe
[6859680.520240]  [<ffffffff812f9af0>] ? out_of_line_wait_on_bit+0x6b/0x77
[6859680.520248]  [<ffffffff81064b28>] ? wake_bit_function+0x0/0x23
[6859680.520257]  [<ffffffff811074cc>] ? sync_inodes_sb+0x73/0x12a
[6859680.520265]  [<ffffffff8110b051>] ? __sync_filesystem+0x4b/0x70
[6859680.520272]  [<ffffffff8110b110>] ? sync_filesystems+0x9a/0xe3
[6859680.520279]  [<ffffffff8110b19e>] ? sys_sync+0x1c/0x2e
[6859680.520291]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

Justin Madru

-----------------------------------------------------------------------------------------------------------------------
Send big files for free. Simple steps. No registration.
Visit now http://www.nawelny.com
