Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0JML2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:28:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43892 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753521Ab0JML2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:28:09 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18JT6YHkpsJ23mLsX8vDqpHjk3rR2NmGcGBwexNpJ
	Z26u5wMLR0t9qa
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Wed, 13 Oct 2010 13:28:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GfZtMITlM23Pvxs"
Message-Id: <201010131328.06465.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GfZtMITlM23Pvxs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

forget to Cc the LKML
=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_GfZtMITlM23Pvxs
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>: Re: UML kernel crash of v2.6.36-rcX kernel
Content-Disposition: inline

From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Wed, 13 Oct 2010 13:27:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
References: <201010121034.03720.toralf.foerster@gmx.de>
In-Reply-To: <201010121034.03720.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201010131327.20085.toralf.foerster@gmx.de>

I can reproduce this behaviour with an UML kernel linux-v2.6.36-rc7-153-
g0acc1b2 if I start the UML guest (an almost stable Gentoo) and then run fr=
om=20
the host system (Gentoo too) this:
=C2=A7> wget http://n22_uml/phpsysinfo/
=2D where n22_uml is the guest and the side is an PHP application :=20
http://phpsysinfo.sourceforge.net/

It is not related to PHP and/or apache b/c phpmyadmin works fine. I argue t=
hat=20
sth is wrong with the reading of /proc and/sys files b/c that is the main p=
art=20
of phpsysinfo.

=46urthermore it is a regression b/c 2.6.35 UML kernel works fine.

Here's the kernel info :

 * Starting local ...                                                      =
                                          =20
[ ok ]
Kernel panic - not syncing: Kernel mode fault at addr 0x4, ip 0x80dc41a
082ecb44:  [<0827380b>] dump_stack+0x22/0x24
082ecb5c:  [<08273870>] panic+0x63/0x167
082ecb84:  [<0805e282>] segv+0x1e2/0x2b0
082ecc3c:  [<0805e391>] segv_handler+0x41/0x60
082ecc5c:  [<0806ea54>] sig_handler_common+0x54/0xa0
082eccd8:  [<0806ebf7>] sig_handler+0x27/0x50
082ecce8:  [<0806ee4c>] handle_signal+0x5c/0xa0
082ecd0c:  [<080711c8>] hard_handler+0x18/0x20
082ecd1c:  [<b7862400>] 0xb7862400


EIP: 0073:[<40000812>] CPU: 0 Not tainted ESP: 007b:bfba8c6c EFLAGS: 000002=
12
    Not tainted
EAX: ffffffda EBX: 08059be8 ECX: 00000054 EDX: bfba8c9c
ESI: 08059bd8 EDI: 40166ff4 EBP: bfba8c78 DS: 007b ES: 007b
082ecaf8:  [<08075e4d>] show_regs+0xed/0x120
082ecb14:  [<0805e5cc>] panic_exit+0x2c/0x50
082ecb24:  [<08099c1e>] notifier_call_chain+0x3e/0x70
082ecb4c:  [<08099ca3>] atomic_notifier_call_chain+0x23/0x30
082ecb5c:  [<08273898>] panic+0x8b/0x167
082ecb84:  [<0805e282>] segv+0x1e2/0x2b0
082ecc3c:  [<0805e391>] segv_handler+0x41/0x60
082ecc5c:  [<0806ea54>] sig_handler_common+0x54/0xa0
082eccd8:  [<0806ebf7>] sig_handler+0x27/0x50
082ecce8:  [<0806ee4c>] handle_signal+0x5c/0xa0
082ecd0c:  [<080711c8>] hard_handler+0x18/0x20
082ecd1c:  [<b7862400>] 0xb7862400

Terminated

=2D-=20
MfG/Kind regards
Toralf F=C3=B6rster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3


--Boundary-00=_GfZtMITlM23Pvxs--
