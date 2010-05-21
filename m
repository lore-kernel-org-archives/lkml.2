Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab0EUQv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:51:56 -0400
Received: from kroah.org ([198.145.64.141]:50273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030Ab0EUQvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:51:50 -0400
Date: Fri, 21 May 2010 09:51:13 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 2.6.35
Message-ID: <20100521165113.GB11216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the tty patches for the .35 merge window.

Nothing big here, just some new drivers and assorted minor fixes and the
like.  Details are below in the shortlog.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree and -mm for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/Kconfig             |   10 +-
 drivers/char/Makefile            |    1 +
 drivers/char/isicom.c            |    8 +-
 drivers/char/n_gsm.c             | 2763 ++++++++++++++++++++++++++++++++++++++
 drivers/char/serial167.c         |  223 +---
 drivers/char/tty_buffer.c        |    2 +-
 drivers/serial/Kconfig           |   82 ++-
 drivers/serial/Makefile          |    2 +
 drivers/serial/altera_jtaguart.c |  504 +++++++
 drivers/serial/altera_uart.c     |  570 ++++++++
 drivers/serial/bfin_sport_uart.c |  209 ++-
 drivers/serial/bfin_sport_uart.h |   27 +-
 drivers/serial/timbuart.c        |   25 +-
 drivers/serial/uartlite.c        |   32 +-
 include/linux/altera_jtaguart.h  |   16 +
 include/linux/altera_uart.h      |   14 +
 include/linux/gsmmux.h           |   25 +
 include/linux/serial_core.h      |    4 +
 include/linux/tty.h              |    3 +-
 19 files changed, 4196 insertions(+), 324 deletions(-)
 create mode 100644 drivers/char/n_gsm.c
 create mode 100644 drivers/serial/altera_jtaguart.c
 create mode 100644 drivers/serial/altera_uart.c
 create mode 100644 include/linux/altera_jtaguart.h
 create mode 100644 include/linux/altera_uart.h
 create mode 100644 include/linux/gsmmux.h

---------------

Alan Cox (1):
      tty: n_gsm line discipline

Christoph Egger (1):
      serial: Tidy REMOTE_DEBUG

Dan Carpenter (1):
      serial: isicomm: handle running out of slots

Johan Hovold (1):
      tty: fix obsolete comment on tty_insert_flip_string_fixed_flag

John Linn (1):
      serial: uartlite: move from byte accesses to word accesses

Mike Frysinger (4):
      serial: bfin_sport_uart: drop useless status masks
      serial: bfin_sport_uart: pull in bfin_sport.h for SPORT defines
      serial: bfin_sport_uart: drop the experimental markings
      serial: bfin_sport_uart: drop redundant cpu depends

Pavan Savoy (1):
      serial: TTY: new ldiscs for staging

Randy Dunlap (1):
      tty: n_gsm: depends on NET

Richard Röjfors (1):
      serial: timbuart: make sure last byte is sent when port is closed

Roel Kluin (1):
      serial: two branches the same in timbuart_set_mctrl()

Sonic Zhang (9):
      serial: bfin_sport_uart: work around anomaly 05000473 (make 32bit fifo read atomic)
      serial: bfin_sport_uart: shorten the SPORT TX waiting loop
      serial: bfin_sport_uart: remove unused peripheral pin lists
      serial: bfin_sport_uart: add missing mapbase initialization
      serial: bfin_sport_uart: rename early platform driver class string
      serial: bfin_sport_uart: add support for CTS/RTS via GPIOs
      serial: bfin_sport_uart: protect changes to uart_port
      serial: bfin_sport_uart: zero sport_uart_port if allocated dynamically
      serial: bfin_sport_uart: only enable SPORT TX if data is to be sent

Tobias Klauser (3):
      serial: Add driver for the Altera JTAG UART
      serial: Add driver for the Altera UART
      serial: bfin_sport_uart: Use resource size to fix off-by-one error

