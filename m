Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0DGJxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:53:06 -0400
Received: from mail66.messagelabs.com ([193.109.254.35]:37286 "HELO
	mail66.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756262Ab0DGJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:52:57 -0400
X-VirusChecked: Checked
X-Env-Sender: davide.ferrari@atrapalo.com
X-Msg-Ref: server-14.tower-66.messagelabs.com!1270633974!57966369!1
X-StarScan-Version: 6.2.4; banners=-,-,-
X-Originating-IP: [88.87.214.78]
From: Davide Ferrari <davide.ferrari@atrapalo.com>
Organization: Atrapalo S.L.
To: linux-kernel@vger.kernel.org
Subject: INFO: task apache2:7601 blocked for more than 120 seconds.
Date: Wed, 7 Apr 2010 11:53:42 +0200
User-Agent: KMail/1.13.1 (Linux/2.6.32-18-generic; KDE/4.4.2; x86_64; ; )
Cc: Davide Ferrari <davide.ferrari@atrapalo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004071153.42752.davide.ferrari@atrapalo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've just installed some new webservers (Apache + mod_php5) on Debian Lenny 
and on some machines I see this message appearing from time to time in the 
kernel log.

[  840.319551] INFO: task apache2:7601 blocked for more than 120 seconds.
[  840.336259] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[  840.353598] apache2       D 0000000000000000     0  7601   6041 0x00000000
[  840.353602]  ffffffff814451f0 0000000000000082 0000000000000000 
0000000000000000
[  840.353605]  0000000000000000 000000000000f8a0 ffff8802126bffd8 
00000000000155c0
[  840.353608]  00000000000155c0 ffff88021158b880 ffff88021158bb78 
00000000126bfe24
[  840.353611] Call Trace:
[  840.353620]  [<ffffffff8110bb35>] ? __getblk+0x26/0x29a
[  840.353623]  [<ffffffff8110c57f>] ? sync_buffer+0x0/0x40
[  840.353629]  [<ffffffff812edf7d>] ? io_schedule+0x73/0xb7
[  840.353631]  [<ffffffff8110c5ba>] ? sync_buffer+0x3b/0x40
[  840.353633]  [<ffffffff812ee380>] ? __wait_on_bit_lock+0x3f/0x84
[  840.353636]  [<ffffffff8110c57f>] ? sync_buffer+0x0/0x40
[  840.353638]  [<ffffffff812ee430>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[  840.353642]  [<ffffffff81064a64>] ? wake_bit_function+0x0/0x23
[  840.353652]  [<ffffffffa0104657>] ? journal_invalidatepage+0x8e/0x282 [jbd]
[  840.353657]  [<ffffffff810bbd4a>] ? truncate_inode_page+0x45/0x84
[  840.353660]  [<ffffffff810bbe33>] ? truncate_inode_pages_range+0xaa/0x2b0
[  840.353666]  [<ffffffffa01262d6>] ? __ext3_journal_dirty_metadata+0x1e/0x46 
[ext3]
[  840.353669]  [<ffffffff812ee7b5>] ? mutex_lock+0xd/0x31
[  840.353674]  [<ffffffff8111513a>] ? fsnotify_clear_marks_by_inode+0x20/0xcd
[  840.353679]  [<ffffffffa011ccd0>] ? ext3_delete_inode+0x0/0xd0 [ext3]
[  840.353683]  [<ffffffffa011cce7>] ? ext3_delete_inode+0x17/0xd0 [ext3]
[  840.353687]  [<ffffffffa011ccd0>] ? ext3_delete_inode+0x0/0xd0 [ext3]
[  840.353692]  [<ffffffff810fee24>] ? generic_delete_inode+0xdc/0x168
[  840.353695]  [<ffffffff810f7c4a>] ? do_unlinkat+0xe2/0x134
[  840.353700]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b


Moreover, this server reaches incredibly high load value (> 150), cause almost 
every Apache process is waiting IO.
It happen both with Lenny (backport) kernel 2.6.30 and 2.6.32. 
I've seen a similiar problem here

http://lkml.org/lkml/2009/1/11/70

and the patch is already applied in my kernel. Anyway it doesn't matter what 
elevator I use (CFQ, deadline), the CPUs are almost always on a high iowait 
(70-80%). The machines it's 8-cores with Hyperthreading and a single SATA 
disk. It doesn't do too much disk activity (circa 200MB logs per day, that's 
no big deal). Any idea? Do you need more info?

Thanks in advance

PS: Please CC me when replying cause I'm not subscribed to the LKML

-- 
Davide Ferrari
Atrapalo.com System Administrator
