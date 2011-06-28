Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1F1Pmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:42:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38435 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758973Ab1F1Pjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:39:53 -0400
X-Sasl-enc: FGY44QSj2rTkeIXdRd23kv5JSgYM67onv75vN74pYCzU 1309275591
Date: Tue, 28 Jun 2011 08:38:56 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY/serial driver fixes for 3.0
Message-ID: <20110628153856.GB32710@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some small tty/serial fixes for the 3.0

The amba serial driver fixes are the biggest, fixing problems that were
causing lockups for users.  Other than that, just a smattering of small
fixes that have been reported as problems by people.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/ tty-linus

All of these patches have been in the -mm and -next trees for a while.

Patches will be sent to the linux-serial mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 arch/arm/mach-exynos4/init.c                     |    1 +
 arch/arm/mach-ux500/board-mop500-pins.c          |   16 ++-
 arch/arm/mach-ux500/board-mop500.c               |   54 ++++++++++
 arch/arm/plat-samsung/include/plat/regs-serial.h |    2 +
 drivers/tty/n_gsm.c                              |   26 ++++-
 drivers/tty/n_tty.c                              |    1 +
 drivers/tty/serial/8250.c                        |    1 +
 drivers/tty/serial/8250_pci.c                    |   59 ++++++++++
 drivers/tty/serial/amba-pl011.c                  |  123 +++++++++++++++++++++-
 drivers/tty/serial/bcm63xx_uart.c                |   18 +++-
 drivers/tty/serial/jsm/jsm_driver.c              |    2 +-
 drivers/tty/serial/s5pv210.c                     |    4 +-
 drivers/tty/tty_ldisc.c                          |    4 +-
 include/linux/amba/serial.h                      |    3 +
 14 files changed, 295 insertions(+), 19 deletions(-)

---------------

Alan Cox (1):
      8250_pci: Fix missing const from merges

Boojin Kim (1):
      ARM: SAMSUNG: serial: Fix on handling of one clock source for UART

Jiri Slaby (2):
      TTY: ldisc, do not close until there are readers
      TTY: ntty, add one more sanity check

Lennart Sorensen (1):
      serial: ioremap warning fix for jsm driver.

Maxime Bizon (1):
      serial: bcm63xx_uart: fix irq storm after rx fifo overrun.

Russ Gorby (2):
      tty: n_gsm: Fixed logic to decode break signal from modem status
      tty: n_gsm: improper skb_pull() use was leaking framed data

Shreshtha Kumar Sahu (2):
      amba pl011: workaround for uart registers lockup
      amba pl011: platform data for reg lockup and glitch v2

Tomoya MORINAGA (1):
      8250_pci: add -ENODEV code for Intel EG20T PCH

leitao@linux.vnet.ibm.com (1):
      8250: Fix capabilities when changing the port type

