Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab0FIVQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:16:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab0FIVQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:16:39 -0400
From: arnd@arndb.de
To: Ales Teska <ales.teska@gmail.com>
Subject: Re: PROBLEM: PPP and other serial port related application hangs in kernel space
Date: Wed, 9 Jun 2010 23:16:32 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>
References: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
In-Reply-To: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006092316.32497.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ebRUICGzwVh20z0ZAJ2gskxOxbeYKKrZLmBf
 0S+ZeeFhDsnyjrzvo7rqdraenkP9L8gckF4yNeneLtHv+ZZWPN
 vClcsFiRy57YlD/197UvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 June 2010 22:46:28 Ales Teska wrote:
> after upgrade of Linux kernel to version 2.6.34 I started to observe following problem 
> - ppp and other serial port related application occasionally (in 1 hour or 1/10 ppp 
> connections) 'hangs' (see description bellow) rendering related serial device unusable.
> I backtracked this issue to 2.6.32.15.
> Application remains in the condition marked as 'D' in 'ps' output (waiting for result
> from kernel space, if I understand that correctly); it stays in this condition forever.

It would be good to find out where exactly the application hangs. Please try a sysrq-t
(press Alt+SysRq+t simultaneously) or cat /proc/<pid-that-hangs>/stack.

It might also be helpful to try running the kernel with CONFIG_LOCKDEP and/or
CONFIG_TTY_MUTEX enabled. For the latter one, you need to get the source
from the tty branch of git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git

> I also found following information in dmesg:
> [ 1673.660876] ------------[ cut here ]------------
> [ 1673.661471] WARNING: at drivers/char/tty_io.c:1278 tty_open+0x213/0x451()
> [ 1673.662358] Modules linked in: ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc ipv6 nvram msr cpuid ledtrig_timer ledtrig_heartbeat ledtrig_default_on geodewdt lm90 hwmon scx200_acb option usbserial ehci_hcd ohci_hcd via_rhine usbcore leds_alix2 mii
> [ 1673.689168] Pid: 1275, comm: ufoprobe_client Not tainted 2.6.34-486-exiprobes #1
> [ 1673.690452] Call Trace:
> [ 1673.690947]  [<c10e93af>] ? tty_open+0x213/0x451
> [ 1673.691926]  [<c1018f51>] warn_slowpath_common+0x45/0x5c
> [ 1673.693006]  [<c1018f75>] warn_slowpath_null+0xd/0x10
> [ 1673.694293]  [<c10e93af>] tty_open+0x213/0x451
> [ 1673.694755]  [<c1068105>] chrdev_open+0xe3/0x126

Do you always see this message exactly once before it hangs?

	Arnd
