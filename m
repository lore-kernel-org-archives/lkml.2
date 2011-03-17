Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1CQWN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:13:28 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:44536 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754926Ab1CQWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:13:26 -0400
X-Greylist: delayed 1484 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 18:13:26 EDT
Subject: Re: known vboxgetty/isdn issue in 2.6.35.3?
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, Karsten Keil <isdn@linux-pingi.de>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Tilman Schmidt <tilman@imap.cc>
In-Reply-To: <201011091115.16351.arnd@arndb.de>
References: <4C864143.5090803@xs4all.nl> <201009072145.10946.arnd@arndb.de>
	 <4CD56087.9000009@xs4all.nl>  <201011091115.16351.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 22:48:41 +0100
Message-ID: <1300398521.16073.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.84.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 09.11.2010, 11:15 +0100 schrieb Arnd Bergmann:
> On Saturday 06 November 2010, Udo van den Heuvel wrote:
> > ==> /proc/16758/stack <==
> > [<c118731a>] tty_unthrottle+0x13/0x3a
> > [<c1185f4e>] reset_buffer_flags+0xd4/0xd9
> > [<c1185f60>] n_tty_flush_buffer+0xd/0x63
> > [<c11888a7>] tty_ldisc_flush+0x1f/0x34
> > [<c120797c>] isdn_tty_modem_result+0x342/0x37c
> > [<c1209c5e>] isdn_tty_modem_hup+0x76/0x176
> > [<c120a66b>] isdn_tty_change_speed+0xa2/0xd4
> > [<c120a6da>] isdn_tty_set_termios+0x3d/0x5a
> > [<c118789b>] set_termios+0x318/0x397
> > [<c1187b41>] tty_mode_ioctl+0x178/0x2db
> > [<c1187de8>] n_tty_ioctl_helper+0x144/0x154
> > [<c11854d9>] n_tty_ioctl+0x97/0xa0
> > [<c1183ccd>] tty_ioctl+0x699/0x6d3
> > [<c108557c>] vfs_ioctl+0x27/0x91
> > [<c1085ade>] do_vfs_ioctl+0x44b/0x47f
> > [<c1085b53>] sys_ioctl+0x41/0x61
> > [<c10027d3>] sysenter_do_call+0x12/0x2d
> > [<ffffffff>] 0xffffffff
> 
> Ok, so it seems that set_termios calls change_termios, which holds the
> termios_mutex while calling isdn_tty_set_termios. This ends up
> calling tty_unthrottle, which tries to take the same mutex, and that fails.
[...]
> Please apply the patch below to see if it helps. We should probably
> have it in 2.6.32-stable and 2.6.35-stable, if there is another one.

The same issue happened on our system. Sometimes vboxgetty gets stuck in
state D on a debian stable system (2.6.32). I just applied your patch to
that kernel and hope the problem went away. Please remind me to report
back in one to two weeks if I didn't already report whether the hangs
are fixed. Is something except for a test on a productive system missing
to get this fix into 32-stable?

Regards,
  Michael Karcher

