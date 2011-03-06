Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab1CFMyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:54:45 -0500
Received: from mail.agmk.net ([91.192.224.71]:39299 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1CFMyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:54:39 -0500
X-Greylist: delayed 1132 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Mar 2011 07:54:39 EST
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: INFO: task ietd:23756 blocked for more than 120 seconds.
Date: Sun, 6 Mar 2011 13:35:36 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.2-2; KDE/4.6.1; x86_64; ; )
Cc: rwalker@medallion.com, arne.redlich@googlemail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061335.37050.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i'm trying to setup a basic iscsi example (one target <-> one initiator, described in tutorials)
but the target oopses, probably during 'ietadm --op delete' called from init.d script.

observed on kernel-2.6.37.1(+grsec+vserver) and iscsitarget-1.4.20.2.

# ps aux|grep iet
root     23756  0.0  0.0      0     0 ?        Ds   12:17   0:00 [ietd]

(...)
[531552.467351] iscsi_trgt: Removing all connections, sessions and targets
[531722.646873] INFO: task ietd:23756 blocked for more than 120 seconds.
[531722.646876] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[531722.646879] ietd          D 00000001097fe18b     0 23756      1 0x00000004
[531722.646884]  ffff880e072b3a18 0000000000000046 ffff880e072b2000 ffff880e072b3938
[531722.646891]  ffff880e072b38d8 ffffffff00000000 ffff880e872b3ab7 000000000000e680
[531722.646896]  000000000000e680 ffff880e072fdb00 000000000000e680 ffff880e072b3fd8
[531722.646901] Call Trace:
[531722.646909]  [<ffffffff81349582>] ? skb_dequeue+0x62/0x80
[531722.646913]  [<ffffffff8125963e>] ? vsnprintf+0x35e/0x620
[531722.646918]  [<ffffffff8144e3a5>] schedule_timeout+0x255/0x2d0
[531722.646922]  [<ffffffff8107335d>] ? up+0x2d/0x50
[531722.646926]  [<ffffffff8104a5a8>] ? release_console_sem+0x1a8/0x1f0
[531722.646930]  [<ffffffff8144f7a8>] __down+0x68/0xb0
[531722.646933]  [<ffffffff8107331c>] down+0x3c/0x50
[531722.646941]  [<ffffffffa0583ac6>] session_del+0x3e6/0x540 [iscsi_trgt]
[531722.646946]  [<ffffffffa05842a7>] target_del_all+0x47/0x230 [iscsi_trgt]
[531722.646951]  [<ffffffffa0581315>] wthread_module_exit+0x45/0x1010 [iscsi_trgt]
[531722.646955]  [<ffffffff8114db12>] fput+0xe2/0x280
[531722.646959]  [<ffffffff81149c2b>] filp_close+0x5b/0x80
[531722.646963]  [<ffffffff8104d6d2>] put_files_struct+0x82/0x110
[531722.646967]  [<ffffffff8104d805>] exit_files+0x45/0x50
[531722.646970]  [<ffffffff8104dcca>] do_exit+0x17a/0x8c0
[531722.646973]  [<ffffffff8144e3a5>] ? schedule_timeout+0x255/0x2d0
[531722.646977]  [<ffffffff810f5705>] ? unlock_page+0x25/0x30
[531722.646981]  [<ffffffff811143e1>] ? __do_fault+0x401/0x510
[531722.646984]  [<ffffffff8104e72f>] do_group_exit+0x4f/0xb0
[531722.646988]  [<ffffffff8105f891>] get_signal_to_deliver+0x3e1/0x450
[531722.646993]  [<ffffffff810020c0>] do_signal+0x70/0x850
[531722.646997]  [<ffffffff8145393c>] ? do_page_fault+0x1dc/0x500
[531722.647001]  [<ffffffff8115eb6b>] ? do_vfs_ioctl+0x9b/0x780
[531722.647004]  [<ffffffff8114c807>] ? vfs_read+0x187/0x1f0
[531722.647008]  [<ffffffff81002925>] do_notify_resume+0x65/0x80
[531722.647011]  [<ffffffff8115f2d1>] ? sys_ioctl+0x81/0xa0
[531722.647015]  [<ffffffff81003115>] int_signal+0x12/0x17

shoud i try a pure kernel? is this stacktrace enough to track the problem?

BR,
Pawel.
