Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0JOPdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:33:45 -0400
Received: from krak.alatek.krakow.pl ([217.96.2.229]:8473 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0JOPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:33:44 -0400
X-Greylist: delayed 1854 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2010 11:33:43 EDT
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.35.5 -> .7] INFO: task rpcbind:14163 blocked for more than 120 seconds.
Date: Fri, 15 Oct 2010 17:02:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.5-1; KDE/4.5.2; x86_64; ; )
Cc: arekm@pld-linux.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151702.15675.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

with the new stable kernel 2.6.35.7 i'm observing on 2 machines
used for development and eda processing (heavy cpu/io/net usage)
following task locking:

[13320.258868] INFO: task rpcbind:14163 blocked for more than 120 seconds.
[13320.258874] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[13320.258888] rpcbind       D 00000000ffffffff     0 14163   2127 0x00000000
[13320.258894]  ffff880041e87cc8 0000000000000086 ffff880041e87d28 
ffff880041e87c78
[13320.258899]  ffff880001886980 0000000000011140 0000000000011140 
0000000000011140
[13320.258903]  ffff880041e87fd8 ffff880041e87fd8 ffff880078fbd580 
0000000000011140
[13320.258907] Call Trace:
[13320.258920]  [<ffffffff810833e9>] ? ktime_get_ts+0xa9/0xe0
[13320.258928]  [<ffffffff810ee9c0>] ? sync_page+0x0/0x50
[13320.258935]  [<ffffffff8143240e>] io_schedule+0x6e/0xb0
[13320.258938]  [<ffffffff810ee9f8>] sync_page+0x38/0x50
[13320.258943]  [<ffffffff81432b92>] __wait_on_bit_lock+0x52/0xb0
[13320.258946]  [<ffffffff810ee9a2>] __lock_page+0x62/0x70
[13320.258952]  [<ffffffff81069ca0>] ? wake_bit_function+0x0/0x40
[13320.258957]  [<ffffffff8110c302>] handle_mm_fault+0xb62/0xba0
[13320.258963]  [<ffffffff81437f25>] do_page_fault+0x145/0x440
[13320.258968]  [<ffffffff8103cf8d>] ? finish_task_switch+0x3d/0xc0
[13320.258972]  [<ffffffff81431e83>] ? schedule+0x2c3/0x7e0
[13320.258975]  [<ffffffff81434cd1>] ? restore_args+0x0/0x30
[13320.258979]  [<ffffffff81434ec4>] page_fault+0x24/0x30

such lock blocks nfs/automounter/machine and only sysrq-reboot helps.
at this momemnt i've downgraded kernel to 2.6.35.5 and it works again.
any hints what to check during limited night-maintance-window?

ps).
please CC me on lkml-reply.

BR,
Pawel.
