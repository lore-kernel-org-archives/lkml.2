Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0IGN6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:58:37 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:51416 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0IGN6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:58:34 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 09:58:33 EDT
Message-ID: <4C864143.5090803@xs4all.nl>
Date: Tue, 07 Sep 2010 15:42:27 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: known vboxgetty/isdn issue in 2.6.35.3?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this in messages:

Sep  2 15:00:22 epia klogd: INFO: task vboxgetty:25662 blocked for more
than 120 seconds.
Sep  2 15:00:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  2 15:00:22 epia klogd: vboxgetty     D 00000000     0 25662      1
0x00000000
Sep  2 15:00:22 epia klogd:  cba29c74 00000046 c1157e3a 00000000
f4c28000 f4c28000 cbb13c4c f4c28000
Sep  2 15:00:22 epia klogd:  cbb13858 f4c28000 00000202 cba29ca4
c1294879 cbb13878 00000202 cbb13878
Sep  2 15:00:22 epia klogd:  cbb13878 f4c28000 cba29c84 ffffffff
cbb13800 cbb13858 cbb13c4c cba29cb4
Sep  2 15:00:22 epia klogd: Call Trace:
Sep  2 15:00:22 epia klogd:  [<c1157e3a>] ? tty_unthrottle+0x13/0x3a
Sep  2 15:00:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
Sep  2 15:00:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
Sep  2 15:00:22 epia klogd:  [<c1156a6e>] reset_buffer_flags+0xd4/0xd9
Sep  2 15:00:22 epia klogd:  [<c1156a80>] n_tty_flush_buffer+0xd/0x63
Sep  2 15:00:22 epia klogd:  [<c11593c7>] tty_ldisc_flush+0x1f/0x34
Sep  2 15:00:22 epia klogd:  [<c11d6e28>] isdn_tty_modem_result+0x342/0x37c
Sep  2 15:00:22 epia klogd:  [<c1153ff3>] ? tty_wakeup+0x46/0x4e
Sep  2 15:00:22 epia klogd:  [<c11d910a>] isdn_tty_modem_hup+0x76/0x176
Sep  2 15:00:22 epia klogd:  [<c115824b>] ? set_termios+0x1a8/0x397
Sep  2 15:00:22 epia klogd:  [<c129476a>] ? mutex_lock_nested+0x2f/0x23f
Sep  2 15:00:22 epia klogd:  [<c11d9b17>] isdn_tty_change_speed+0xa2/0xd4
Sep  2 15:00:22 epia klogd:  [<c11d9b86>] isdn_tty_set_termios+0x3d/0x5a
Sep  2 15:00:22 epia klogd:  [<c11583bb>] set_termios+0x318/0x397
Sep  2 15:00:22 epia klogd:  [<c1158661>] tty_mode_ioctl+0x178/0x2db
Sep  2 15:00:22 epia klogd:  [<c1158a06>] ? tty_ldisc_try+0x11/0x38
Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:00:22 epia klogd:  [<c1158908>] n_tty_ioctl_helper+0x144/0x154
Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:00:22 epia klogd:  [<c1155ff9>] n_tty_ioctl+0x97/0xa0
Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:00:22 epia klogd:  [<c11547ed>] tty_ioctl+0x699/0x6d3
Sep  2 15:00:22 epia klogd:  [<c1083788>] vfs_ioctl+0x27/0x91
Sep  2 15:00:22 epia klogd:  [<c1154154>] ? tty_ioctl+0x0/0x6d3
Sep  2 15:00:22 epia klogd:  [<c1083d06>] do_vfs_ioctl+0x467/0x4a5
Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:00:22 epia klogd:  [<c1209c83>] ? net_tx_action+0x47/0xcc
Sep  2 15:00:22 epia klogd:  [<c102262a>] ? __do_softirq+0xc3/0xd2
Sep  2 15:00:22 epia klogd:  [<c1083d85>] sys_ioctl+0x41/0x61
Sep  2 15:00:22 epia klogd:  [<c1003cb9>] ? do_IRQ+0x74/0x87
Sep  2 15:00:22 epia klogd:  [<c1002813>] sysenter_do_call+0x12/0x2d
Sep  2 15:00:22 epia klogd: INFO: lockdep is turned off.


Sep  2 15:02:22 epia klogd: INFO: task vboxgetty:25662 blocked for more
than 120 seconds.
Sep  2 15:02:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  2 15:02:22 epia klogd: vboxgetty     D 00000000     0 25662      1
0x00000000
Sep  2 15:02:22 epia klogd:  cba29c74 00000046 c1157e3a 00000000
f4c28000 f4c28000 cbb13c4c f4c28000
Sep  2 15:02:22 epia klogd:  cbb13858 f4c28000 00000202 cba29ca4
c1294879 cbb13878 00000202 cbb13878
Sep  2 15:02:22 epia klogd:  cbb13878 f4c28000 cba29c84 ffffffff
cbb13800 cbb13858 cbb13c4c cba29cb4
Sep  2 15:02:22 epia klogd: Call Trace:
Sep  2 15:02:22 epia klogd:  [<c1157e3a>] ? tty_unthrottle+0x13/0x3a
Sep  2 15:02:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
Sep  2 15:02:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
Sep  2 15:02:22 epia klogd:  [<c1156a6e>] reset_buffer_flags+0xd4/0xd9
Sep  2 15:02:22 epia klogd:  [<c1156a80>] n_tty_flush_buffer+0xd/0x63
Sep  2 15:02:22 epia klogd:  [<c11593c7>] tty_ldisc_flush+0x1f/0x34
Sep  2 15:02:22 epia klogd:  [<c11d6e28>] isdn_tty_modem_result+0x342/0x37c
Sep  2 15:02:22 epia klogd:  [<c1153ff3>] ? tty_wakeup+0x46/0x4e
Sep  2 15:02:22 epia klogd:  [<c11d910a>] isdn_tty_modem_hup+0x76/0x176
Sep  2 15:02:22 epia klogd:  [<c115824b>] ? set_termios+0x1a8/0x397
Sep  2 15:02:22 epia klogd:  [<c129476a>] ? mutex_lock_nested+0x2f/0x23f
Sep  2 15:02:22 epia klogd:  [<c11d9b17>] isdn_tty_change_speed+0xa2/0xd4
Sep  2 15:02:22 epia klogd:  [<c11d9b86>] isdn_tty_set_termios+0x3d/0x5a
Sep  2 15:02:22 epia klogd:  [<c11583bb>] set_termios+0x318/0x397
Sep  2 15:02:22 epia klogd:  [<c1158661>] tty_mode_ioctl+0x178/0x2db
Sep  2 15:02:22 epia klogd:  [<c1158a06>] ? tty_ldisc_try+0x11/0x38
Sep  2 15:02:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:02:22 epia klogd:  [<c1158908>] n_tty_ioctl_helper+0x144/0x154
Sep  2 15:02:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:02:22 epia klogd:  [<c1155ff9>] n_tty_ioctl+0x97/0xa0
Sep  2 15:02:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:02:22 epia klogd:  [<c11547ed>] tty_ioctl+0x699/0x6d3
Sep  2 15:02:22 epia klogd:  [<c1083788>] vfs_ioctl+0x27/0x91
Sep  2 15:02:22 epia klogd:  [<c1154154>] ? tty_ioctl+0x0/0x6d3
Sep  2 15:02:22 epia klogd:  [<c1083d06>] do_vfs_ioctl+0x467/0x4a5
Sep  2 15:02:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:02:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:02:22 epia klogd:  [<c1209c83>] ? net_tx_action+0x47/0xcc
Sep  2 15:02:22 epia klogd:  [<c102262a>] ? __do_softirq+0xc3/0xd2
Sep  2 15:02:22 epia klogd:  [<c1083d85>] sys_ioctl+0x41/0x61
Sep  2 15:02:22 epia klogd:  [<c1003cb9>] ? do_IRQ+0x74/0x87
Sep  2 15:02:22 epia klogd:  [<c1002813>] sysenter_do_call+0x12/0x2d
Sep  2 15:02:22 epia klogd: INFO: lockdep is turned off.


Sep  2 15:04:22 epia klogd: INFO: task vboxgetty:25662 blocked for more
than 120 seconds.
Sep  2 15:04:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep  2 15:04:22 epia klogd: vboxgetty     D 00000000     0 25662      1
0x00000000
Sep  2 15:04:22 epia klogd:  cba29c74 00000046 c1157e3a 00000000
f4c28000 f4c28000 cbb13c4c f4c28000
Sep  2 15:04:22 epia klogd:  cbb13858 f4c28000 00000202 cba29ca4
c1294879 cbb13878 00000202 cbb13878
Sep  2 15:04:22 epia klogd:  cbb13878 f4c28000 cba29c84 ffffffff
cbb13800 cbb13858 cbb13c4c cba29cb4
Sep  2 15:04:22 epia klogd: Call Trace:
Sep  2 15:04:22 epia klogd:  [<c1157e3a>] ? tty_unthrottle+0x13/0x3a
Sep  2 15:04:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
Sep  2 15:04:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
Sep  2 15:04:22 epia klogd:  [<c1156a6e>] reset_buffer_flags+0xd4/0xd9
Sep  2 15:04:22 epia klogd:  [<c1156a80>] n_tty_flush_buffer+0xd/0x63
Sep  2 15:04:22 epia klogd:  [<c11593c7>] tty_ldisc_flush+0x1f/0x34
Sep  2 15:04:22 epia klogd:  [<c11d6e28>] isdn_tty_modem_result+0x342/0x37c
Sep  2 15:04:22 epia klogd:  [<c1153ff3>] ? tty_wakeup+0x46/0x4e
Sep  2 15:04:22 epia klogd:  [<c11d910a>] isdn_tty_modem_hup+0x76/0x176
Sep  2 15:04:22 epia klogd:  [<c115824b>] ? set_termios+0x1a8/0x397
Sep  2 15:04:22 epia klogd:  [<c129476a>] ? mutex_lock_nested+0x2f/0x23f
Sep  2 15:04:22 epia klogd:  [<c11d9b17>] isdn_tty_change_speed+0xa2/0xd4
Sep  2 15:04:22 epia klogd:  [<c11d9b86>] isdn_tty_set_termios+0x3d/0x5a
Sep  2 15:04:22 epia klogd:  [<c11583bb>] set_termios+0x318/0x397
Sep  2 15:04:22 epia klogd:  [<c1158661>] tty_mode_ioctl+0x178/0x2db
Sep  2 15:04:22 epia klogd:  [<c1158a06>] ? tty_ldisc_try+0x11/0x38
Sep  2 15:04:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:04:22 epia klogd:  [<c1158908>] n_tty_ioctl_helper+0x144/0x154
Sep  2 15:04:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:04:22 epia klogd:  [<c1155ff9>] n_tty_ioctl+0x97/0xa0
Sep  2 15:04:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
Sep  2 15:04:22 epia klogd:  [<c11547ed>] tty_ioctl+0x699/0x6d3
Sep  2 15:04:22 epia klogd:  [<c1083788>] vfs_ioctl+0x27/0x91
Sep  2 15:04:22 epia klogd:  [<c1154154>] ? tty_ioctl+0x0/0x6d3
Sep  2 15:04:22 epia klogd:  [<c1083d06>] do_vfs_ioctl+0x467/0x4a5
Sep  2 15:04:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:04:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
Sep  2 15:04:22 epia klogd:  [<c1209c83>] ? net_tx_action+0x47/0xcc
Sep  2 15:04:22 epia klogd:  [<c102262a>] ? __do_softirq+0xc3/0xd2
Sep  2 15:04:22 epia klogd:  [<c1083d85>] sys_ioctl+0x41/0x61
Sep  2 15:04:22 epia klogd:  [<c1003cb9>] ? do_IRQ+0x74/0x87
Sep  2 15:04:22 epia klogd:  [<c1002813>] sysenter_do_call+0x12/0x2d
Sep  2 15:04:22 epia klogd: INFO: lockdep is turned off.

(etc)

Load went to 1.0 and up even while the box was 90%+ idle.
Why did this happen?
How to debug?


Kind regards,
Udo
