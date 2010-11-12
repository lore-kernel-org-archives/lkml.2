Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0KLVeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:34:23 -0500
Received: from kroah.org ([198.145.64.141]:57075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab0KLVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:34:19 -0500
Date: Fri, 12 Nov 2010 13:32:15 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [GIT PATCH] TTY/serial fixes for .37-rc1
Message-ID: <20101112213215.GB9294@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of tty and serial fixes for your .37-rc1 tree.

Full details are below, but there's just a range of bug fixes all over
the place, some of them having lived in the tree for quite some time,
and it's nice to get them finally resolved.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 MAINTAINERS                       |    4 +-
 drivers/char/amiserial.c          |    1 -
 drivers/char/nozomi.c             |    1 -
 drivers/char/pcmcia/synclink_cs.c |    1 +
 drivers/serial/8250.c             |    5 +++-
 drivers/serial/8250_pci.c         |    5 ++++
 drivers/serial/bfin_5xx.c         |   31 ++++++++++++++++-------
 drivers/tty/n_gsm.c               |    5 ++-
 drivers/tty/tty_buffer.c          |   14 +++++++++-
 drivers/tty/tty_ldisc.c           |   49 +++++++++++++++++++++++++++++++-----
 drivers/tty/vt/vc_screen.c        |    6 ++--
 include/linux/tty.h               |    2 +-
 12 files changed, 94 insertions(+), 30 deletions(-)

---------------

Alan Cox (2):
      tty: Fix formatting in tty.h
      nozomi: Fix warning from the previous TIOCGCOUNT changes

Andres Salomon (1):
      tty: fix warning in synclink driver

Geert Uytterhoeven (1):
      amiserial: Remove unused variable icount

Greg Kroah-Hartman (1):
      tty: the development tree is now done in git

Jiri Olsa (1):
      tty: prevent DOS in the flush_to_ldisc

Jiri Slaby (1):
      TTY: restore tty_ldisc_wait_idle

Joe Perches (1):
      drivers/serial/bfin_5xx.c: Fix line continuation defects

Ken Mills (2):
      n_gsm: Copy n2 over when configuring via ioctl interface
      n_gsm: Fix length handling

Lawrence Rust (1):
      8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang

Maciej Szmigiero (1):
      SERIAL: blacklist si3052 chip

Mikulas Patocka (1):
      8250: add support for Kouwell KW-L221N-2

Nicolas Pitre (1):
      vcs: make proper usage of the poll flags

Philippe Rétornaz (1):
      tty_ldisc: Fix BUG() on hangup

Sonic Zhang (4):
      serial: bfin_5xx: always include DMA headers
      serial: bfin_5xx: remove redundant SSYNC to improve TX speed
      serial: bfin_5xx: disable CON_PRINTBUFFER for consoles
      serial: bfin_5xx: grab port lock before making port termios changes

