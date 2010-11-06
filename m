Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0KFLY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:24:28 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:46607 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KFLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:24:27 -0400
Message-ID: <4CD53AE6.5090204@xs4all.nl>
Date: Sat, 06 Nov 2010 12:24:22 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: task vboxgetty:16758 blocked for more than 120 seconds.   2.6.35.7
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is 2.6.35.7-ts15 (stock kernel plus Alexander Gordeev's hardpps
patches).
A call came in via my isdn card.
Then stuff happened:


Nov  3 16:01:40 epia klogd: isdn_net: Incoming call without OAD,
assuming '0'
Nov  3 16:01:40 epia klogd: isdn_net: call from 0 -> 0 1xxxxxxxxxxxxx
ignored
Nov  3 16:01:40 epia klogd: isdn_tty: Incoming call without OAD,
assuming '0'
Nov  3 16:01:40 epia klogd: isdn_tty: call from 0, -> RING on ttyI0

Nov  3 16:05:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:05:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:05:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:05:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:05:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:05:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:05:22 epia klogd: Call Trace:
Nov  3 16:05:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:05:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:05:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:05:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:05:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:05:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:05:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:05:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:05:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:05:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:05:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:05:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:05:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:05:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:05:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:05:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:05:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:05:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:05:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:05:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:05:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:05:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:05:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:05:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:05:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:05:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:05:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:05:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:05:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:05:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:05:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:05:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:05:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:05:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:05:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:07:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:07:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:07:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:07:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:07:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:07:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:07:22 epia klogd: Call Trace:
Nov  3 16:07:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:07:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:07:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:07:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:07:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:07:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:07:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:07:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:07:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:07:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:07:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:07:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:07:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:07:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:07:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:07:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:07:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:07:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:07:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:07:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:07:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:07:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:07:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:07:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:07:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:07:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:07:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:07:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:07:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:07:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:07:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:07:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:07:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:07:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:07:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:09:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:09:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:09:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:09:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:09:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:09:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:09:22 epia klogd: Call Trace:
Nov  3 16:09:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:09:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:09:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:09:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:09:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:09:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:09:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:09:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:09:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:09:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:09:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:09:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:09:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:09:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:09:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:09:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:09:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:09:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:09:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:09:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:09:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:09:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:09:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:09:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:09:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:09:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:09:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:09:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:09:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:09:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:09:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:09:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:09:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:09:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:09:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:11:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:11:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:11:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:11:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:11:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:11:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:11:22 epia klogd: Call Trace:
Nov  3 16:11:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:11:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:11:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:11:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:11:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:11:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:11:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:11:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:11:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:11:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:11:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:11:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:11:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:11:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:11:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:11:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:11:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:11:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:11:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:11:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:11:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:11:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:11:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:11:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:11:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:11:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:11:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:11:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:11:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:11:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:11:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:11:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:11:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:11:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:11:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:13:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:13:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:13:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:13:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:13:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:13:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:13:22 epia klogd: Call Trace:
Nov  3 16:13:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:13:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:13:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:13:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:13:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:13:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:13:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:13:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:13:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:13:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:13:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:13:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:13:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:13:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:13:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:13:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:13:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:13:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:13:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:13:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:13:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:13:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:13:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:13:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:13:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:13:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:13:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:13:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:13:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:13:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:13:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:13:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:13:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:13:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:13:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:15:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:15:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:15:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:15:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:15:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:15:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:15:22 epia klogd: Call Trace:
Nov  3 16:15:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:15:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:15:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:15:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:15:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:15:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:15:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:15:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:15:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:15:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:15:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:15:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:15:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:15:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:15:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:15:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:15:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:15:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:15:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:15:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:15:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:15:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:15:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:15:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:15:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:15:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:15:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:15:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:15:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:15:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:15:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:15:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:15:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:15:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:15:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:17:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:17:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:17:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:17:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:17:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:17:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:17:22 epia klogd: Call Trace:
Nov  3 16:17:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:17:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:17:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:17:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:17:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:17:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:17:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:17:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:17:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:17:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:17:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:17:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:17:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:17:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:17:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:17:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:17:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:17:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:17:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:17:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:17:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:17:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:17:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:17:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:17:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:17:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:17:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:17:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:17:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:17:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:17:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:17:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:17:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:17:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:17:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a


Nov  3 16:19:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:19:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:19:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:19:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:19:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:19:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:19:22 epia klogd: Call Trace:
Nov  3 16:19:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:19:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:19:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:19:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:19:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:19:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:19:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:19:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:19:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:19:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:19:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:19:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:19:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:19:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:19:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:19:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:19:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:19:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:19:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:19:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:19:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:19:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:19:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:19:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:19:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:19:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:19:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:19:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:19:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:19:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:19:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:19:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:19:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:19:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:19:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:21:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:21:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:21:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:21:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:21:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:21:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:21:22 epia klogd: Call Trace:
Nov  3 16:21:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:21:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:21:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:21:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:21:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:21:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:21:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:21:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:21:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:21:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:21:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:21:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:21:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:21:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:21:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:21:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:21:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:21:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:21:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:21:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:21:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:21:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:21:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:21:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:21:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:21:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:21:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:21:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:21:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:21:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:21:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:21:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:21:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:21:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:21:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a

Nov  3 16:23:22 epia klogd: INFO: task vboxgetty:16758 blocked for more
than 120 seconds.
Nov  3 16:23:22 epia klogd: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  3 16:23:22 epia klogd: vboxgetty     D f6b2f858     0 16758      1
0x00000000
Nov  3 16:23:22 epia klogd:  df015c78 00000046 00000000 f6b2f858
f70ee840 f70ee840 f70ee840 f6b2f858
Nov  3 16:23:22 epia klogd:  f70ee840 ffffffff df015ca4 c12cac95
f6b2f878 00000246 f6b2f878 f6b2f878
Nov  3 16:23:22 epia klogd:  f70ee840 df015c88 f6b2f800 f6b2f858
f6b2fc50 df015cb4 c118731a f6b2f800
Nov  3 16:23:22 epia klogd: Call Trace:
Nov  3 16:23:22 epia klogd:  [<c12cac95>] mutex_lock_nested+0x125/0x225
Nov  3 16:23:22 epia klogd:  [<c118731a>] tty_unthrottle+0x13/0x3a
Nov  3 16:23:22 epia klogd:  [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
Nov  3 16:23:22 epia klogd:  [<c1185f60>] n_tty_flush_buffer+0xd/0x63
Nov  3 16:23:22 epia klogd:  [<c11888a7>] tty_ldisc_flush+0x1f/0x34
Nov  3 16:23:22 epia klogd:  [<c120797c>] isdn_tty_modem_result+0x342/0x37c
Nov  3 16:23:22 epia klogd:  [<c11834d3>] ? tty_wakeup+0x46/0x4e
Nov  3 16:23:22 epia klogd:  [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
Nov  3 16:23:22 epia klogd:  [<c118772b>] ? set_termios+0x1a8/0x397
Nov  3 16:23:22 epia klogd:  [<c12cab9f>] ? mutex_lock_nested+0x2f/0x225
Nov  3 16:23:22 epia klogd:  [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
Nov  3 16:23:22 epia klogd:  [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
Nov  3 16:23:22 epia klogd:  [<c118789b>] set_termios+0x318/0x397
Nov  3 16:23:22 epia klogd:  [<c1187b41>] tty_mode_ioctl+0x178/0x2db
Nov  3 16:23:22 epia klogd:  [<c1187ee6>] ? tty_ldisc_try+0x11/0x38
Nov  3 16:23:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:23:22 epia klogd:  [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
Nov  3 16:23:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:23:22 epia klogd:  [<c11854d9>] n_tty_ioctl+0x97/0xa0
Nov  3 16:23:22 epia klogd:  [<c1185442>] ? n_tty_ioctl+0x0/0xa0
Nov  3 16:23:22 epia klogd:  [<c1183ccd>] tty_ioctl+0x699/0x6d3
Nov  3 16:23:22 epia klogd:  [<c1003b5d>] ? do_IRQ+0x74/0x87
Nov  3 16:23:22 epia klogd:  [<c108557c>] vfs_ioctl+0x27/0x91
Nov  3 16:23:22 epia klogd:  [<c1183634>] ? tty_ioctl+0x0/0x6d3
Nov  3 16:23:22 epia klogd:  [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
Nov  3 16:23:22 epia klogd:  [<c1188240>] ? tty_ldisc_deref+0x8/0xa
Nov  3 16:23:22 epia klogd:  [<c118204a>] ? tty_read+0x72/0x9e
Nov  3 16:23:22 epia klogd:  [<c1185887>] ? n_tty_read+0x0/0x5f3
Nov  3 16:23:22 epia klogd:  [<c107ada8>] ? vfs_read+0x88/0x110
Nov  3 16:23:22 epia klogd:  [<c1181fd8>] ? tty_read+0x0/0x9e
Nov  3 16:23:22 epia klogd:  [<c1085b53>] sys_ioctl+0x41/0x61
Nov  3 16:23:22 epia klogd:  [<c10027d3>] sysenter_do_call+0x12/0x2d
Nov  3 16:23:22 epia klogd: 2 locks held by vboxgetty/16758:
Nov  3 16:23:22 epia klogd:  #0:  (&tty->termios_mutex){......}, at:
[<c118772b>] set_termios+0x1a8/0x397
Nov  3 16:23:22 epia klogd:  #1:  (&tty->termios_mutex){......}, at:
[<c118731a>] tty_unthrottle+0x13/0x3a


How can I help fix this?
Please let me know.


Thanks,
Udo
