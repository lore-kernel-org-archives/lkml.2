Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1AIVhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:37:31 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:36783 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1AIVha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:37:30 -0500
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jan 2011 16:37:29 EST
Date: Sun, 9 Jan 2011 22:06:42 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: cluster-devel@redhat.com, Linux kernel list <linux-kernel@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz
Subject: 2.6.37 - GFS2 trouble
Message-ID: <20110109210642.GG2400@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4357152 records (last update: 20110109)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I wanted to try 2.6.37 on my cluster, but all tasks trying to access GFS2-mounted
partition got stuck. Kernel started spitting following messages:

Jan  5 22:16:46 vbox1 [ 3001.948125] INFO: task gfs2_quotad:12532 blocked for more than 120 seconds.
Jan  5 22:16:46 vbox1 [ 3001.948137] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  5 22:16:46 vbox1 [ 3001.948141] gfs2_quotad   D ffffffff8140a4c0     0 12532      2 0x00000080
Jan  5 22:16:46 vbox1 [ 3001.948149]  ffff88040465fc30 0000000000000046 ffff88040465fb20 00000000000116c0
Jan  5 22:16:46 vbox1 [ 3001.948156]  ffff8804054b48d8 0000000000000007 ffff8804054b4530 ffff88042fd45c40
Jan  5 22:16:46 vbox1 [ 3001.948163]  ffff88040465ffd8 0000000000000000 000000000465fb50 ffffffff8136cce3
Jan  5 22:16:46 vbox1 [ 3001.948170] Call Trace:
Jan  5 22:16:46 vbox1 [ 3001.948184]  [<ffffffff8136cce3>] ? _raw_spin_unlock+0x13/0x40
Jan  5 22:16:46 vbox1 [ 3001.948199]  [<ffffffffa04c3d38>] ? dlm_put_lockspace+0x28/0x30 [dlm]
Jan  5 22:16:46 vbox1 [ 3001.948208]  [<ffffffffa04c2066>] ? dlm_lock+0x86/0x180 [dlm]
Jan  5 22:16:46 vbox1 [ 3001.948228]  [<ffffffffa05696c0>] ? gdlm_bast+0x0/0x50 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948233]  [<ffffffff81045862>] ? update_curr+0xb2/0x170
Jan  5 22:16:46 vbox1 [ 3001.948239]  [<ffffffff8103ad61>] ? get_parent_ip+0x11/0x50
Jan  5 22:16:46 vbox1 [ 3001.948243]  [<ffffffff8103c4bd>] ? sub_preempt_count+0x9d/0xd0
Jan  5 22:16:46 vbox1 [ 3001.948249]  [<ffffffff8136cc9d>] ? _raw_spin_unlock_irqrestore+0x1d/0x50
Jan  5 22:16:46 vbox1 [ 3001.948260]  [<ffffffffa054a149>] gfs2_glock_holder_wait+0x9/0x10 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948265]  [<ffffffff8136a9e5>] __wait_on_bit+0x55/0x80
Jan  5 22:16:46 vbox1 [ 3001.948275]  [<ffffffffa054a140>] ? gfs2_glock_holder_wait+0x0/0x10 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948285]  [<ffffffffa054a140>] ? gfs2_glock_holder_wait+0x0/0x10 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948291]  [<ffffffff8136aa88>] out_of_line_wait_on_bit+0x78/0x90
Jan  5 22:16:46 vbox1 [ 3001.948296]  [<ffffffff8106ae70>] ? wake_bit_function+0x0/0x30
Jan  5 22:16:46 vbox1 [ 3001.948301]  [<ffffffff8103ad61>] ? get_parent_ip+0x11/0x50
Jan  5 22:16:46 vbox1 [ 3001.948311]  [<ffffffffa054a192>] gfs2_glock_wait+0x42/0x50 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948323]  [<ffffffffa054bc8d>] gfs2_glock_nq+0x28d/0x3a0 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948336]  [<ffffffffa0565fe9>] gfs2_statfs_sync+0x59/0x1a0 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948350]  [<ffffffffa0565fe1>] ? gfs2_statfs_sync+0x51/0x1a0 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948354]  [<ffffffff8103c4bd>] ? sub_preempt_count+0x9d/0xd0
Jan  5 22:16:46 vbox1 [ 3001.948368]  [<ffffffffa055ec97>] quotad_check_timeo+0x57/0x90 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948381]  [<ffffffffa05606d7>] gfs2_quotad+0x207/0x240 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948386]  [<ffffffff8106ae30>] ? autoremove_wake_function+0x0/0x40
Jan  5 22:16:46 vbox1 [ 3001.948391]  [<ffffffff8136cc9d>] ? _raw_spin_unlock_irqrestore+0x1d/0x50
Jan  5 22:16:46 vbox1 [ 3001.948404]  [<ffffffffa05604d0>] ? gfs2_quotad+0x0/0x240 [gfs2]
Jan  5 22:16:46 vbox1 [ 3001.948409]  [<ffffffff8106a906>] kthread+0x96/0xa0
Jan  5 22:16:46 vbox1 [ 3001.948416]  [<ffffffff810032d4>] kernel_thread_helper+0x4/0x10
Jan  5 22:16:46 vbox1 [ 3001.948420]  [<ffffffff8106a870>] ? kthread+0x0/0xa0
Jan  5 22:16:46 vbox1 [ 3001.948425]  [<ffffffff810032d0>] ? kernel_thread_helper+0x0/0x10

Could somebody with insight have a look at this? Is it some known problem? 
If I could somehow help to debug, I'll be happy to do so.
cheers
nik


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
