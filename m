Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab0IGTpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:45:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0IGTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:45:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>, Karsten Keil <isdn@linux-pingi.de>,
        Greg KH <gregkh@suse.de>
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
Date: Tue, 7 Sep 2010 21:45:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <4C864143.5090803@xs4all.nl>
In-Reply-To: <4C864143.5090803@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009072145.10946.arnd@arndb.de>
X-Provags-ID: V02:K0:dgJ/hZbHtXdVtqH9fZE0vk/n8N3DyHcRon6vfCKj2ie
 432j5jxMzde4CyjtSIYzYzcRt1XS4Uf4X2HHy50829T2Gturbf
 OGbthUoyr18qANHD1LSWZrWIYCmuWr9L5thlNpHvlQ35yDfbbv
 QaQ6QoC740M6WhRl7OAcYI9kkuEKuzmXXVu2v8J4MLy1SUsCt3
 i9Y9jD5VHdo2QyiH2m5sA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010 15:42:27 Udo van den Heuvel wrote:
> Sep  2 15:00:22 epia klogd: INFO: task vboxgetty:25662 blocked for more
> than 120 seconds.
>
> Sep  2 15:00:22 epia klogd: Call Trace:
> Sep  2 15:00:22 epia klogd:  [<c1157e3a>] ? tty_unthrottle+0x13/0x3a
> Sep  2 15:00:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
> Sep  2 15:00:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a

It appears that the process deadlocks on tty->termios_mutex.

> Sep  2 15:00:22 epia klogd:  [<c1294879>] mutex_lock_nested+0x13e/0x23f
> Sep  2 15:00:22 epia klogd:  [<c1157e3a>] tty_unthrottle+0x13/0x3a
> Sep  2 15:00:22 epia klogd:  [<c1156a6e>] reset_buffer_flags+0xd4/0xd9
> Sep  2 15:00:22 epia klogd:  [<c1156a80>] n_tty_flush_buffer+0xd/0x63
> Sep  2 15:00:22 epia klogd:  [<c11593c7>] tty_ldisc_flush+0x1f/0x34
> Sep  2 15:00:22 epia klogd:  [<c11d6e28>] isdn_tty_modem_result+0x342/0x37c
> Sep  2 15:00:22 epia klogd:  [<c1153ff3>] ? tty_wakeup+0x46/0x4e
> Sep  2 15:00:22 epia klogd:  [<c11d910a>] isdn_tty_modem_hup+0x76/0x176
> Sep  2 15:00:22 epia klogd:  [<c115824b>] ? set_termios+0x1a8/0x397
> Sep  2 15:00:22 epia klogd:  [<c129476a>] ? mutex_lock_nested+0x2f/0x23f
> Sep  2 15:00:22 epia klogd:  [<c11d9b17>] isdn_tty_change_speed+0xa2/0xd4
> Sep  2 15:00:22 epia klogd:  [<c11d9b86>] isdn_tty_set_termios+0x3d/0x5a
> Sep  2 15:00:22 epia klogd:  [<c11583bb>] set_termios+0x318/0x397
> Sep  2 15:00:22 epia klogd:  [<c1158661>] tty_mode_ioctl+0x178/0x2db
> Sep  2 15:00:22 epia klogd:  [<c1158a06>] ? tty_ldisc_try+0x11/0x38
> Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> Sep  2 15:00:22 epia klogd:  [<c1158908>] n_tty_ioctl_helper+0x144/0x154
> Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> Sep  2 15:00:22 epia klogd:  [<c1155ff9>] n_tty_ioctl+0x97/0xa0
> Sep  2 15:00:22 epia klogd:  [<c1155f62>] ? n_tty_ioctl+0x0/0xa0
> Sep  2 15:00:22 epia klogd:  [<c11547ed>] tty_ioctl+0x699/0x6d3
> Sep  2 15:00:22 epia klogd:  [<c1083788>] vfs_ioctl+0x27/0x91
> Sep  2 15:00:22 epia klogd:  [<c1154154>] ? tty_ioctl+0x0/0x6d3
> Sep  2 15:00:22 epia klogd:  [<c1083d06>] do_vfs_ioctl+0x467/0x4a5
> Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
> Sep  2 15:00:22 epia klogd:  [<c1205478>] ? __kfree_skb+0x68/0x6b
> Sep  2 15:00:22 epia klogd:  [<c1209c83>] ? net_tx_action+0x47/0xcc
> Sep  2 15:00:22 epia klogd:  [<c102262a>] ? __do_softirq+0xc3/0xd2
> Sep  2 15:00:22 epia klogd:  [<c1083d85>] sys_ioctl+0x41/0x61
> Sep  2 15:00:22 epia klogd:  [<c1003cb9>] ? do_IRQ+0x74/0x87
> Sep  2 15:00:22 epia klogd:  [<c1002813>] sysenter_do_call+0x12/0x2d

This happened when vboxgetty was doing an ioctl on an ISDN tty, apparently
while the TTY was getting hung up.

> Sep  2 15:00:22 epia klogd: INFO: lockdep is turned off.

Enabling CONFIG_LOCKDEP in your .config should provide better
information if you can reproduce it.

> Load went to 1.0 and up even while the box was 90%+ idle.
> Why did this happen?

When waiting uninterruptible for a mutex, we treat the process as busy,
even though it is not doing anything. The question is why it is waiting
for a mutex that should never be held for an extended time.

> How to debug?

One thing to check is if there are other processes blocked as well
that may be holding the mutex.

Can you send the output of "head -n 20 /proc/*/stack"? If
CONFIG_LOCKDEP gives you more data, that would be even better.

Another thing to try is to run 2.6.36-rc3. We just did a major change
to the locking in the tty subsystem, so if the behavior is different
there, that may be an explanation.

I also took Greg and Karten on Cc, they maintain the TTY and ISDN code
that is involved in the code path in question. Maybe one of them already
knows the answer.

	Arnd
