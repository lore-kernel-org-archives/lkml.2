Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab2JSS03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:26:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44985 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab2JSS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:26:26 -0400
Date: Fri, 19 Oct 2012 11:26:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [GIT PATCH] TTY patches for 3.7-rc2
Message-ID: <20121019182622.GA32140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git/ tags/tty-3.7-rc1

for you to fetch changes up to 178e485a0ebbfdb7165b4363d8fea2a07d650c0b:

  staging: dgrp: check return value of alloc_tty_driver (2012-10-17 14:10:10 -0700)

----------------------------------------------------------------
TTY fixes for 3.7-rc2

Here are some tty and serial driver fixes for your 3.7-rc1 tree.

Again, the UABI header file fixes, and a number of build and runtime serial
driver bugfixes that solve problems people have been reporting (the staging
driver is a tty driver, hence the fixes coming in through this tree.)

All of these have been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Shiyan (1):
      serial: sccnxp: Allows the driver to be compiled as a module

Bill Pemberton (2):
      staging: dgrp: check for NULL pointer in (un)register_proc_table
      staging: dgrp: check return value of alloc_tty_driver

David Howells (1):
      UAPI: (Scripted) Disintegrate include/linux/hsi

Geert Uytterhoeven (2):
      staging: serial: dgrp: Add missing #include <linux/uaccess.h>
      serial/8250_hp300: Missing 8250 register interface conversion bits

Greg Kroah-Hartman (3):
      tty: serial: sccnxp: Fix bug with unterminated platform_id list
      Merge 3.7-rc1 into tty-linus
      Merge tag 'disintegrate-tty-20121009' of git://git.infradead.org/users/dhowells/linux-headers into tty-linus

Markus Trippelsdorf (1):
      tty: Fix bogus "callbacks suppressed" messages

Sasha Levin (1):
      net, TTY: initialize tty->driver_data before usage

 drivers/staging/dgrp/dgrp_mon_ops.c     |  1 +
 drivers/staging/dgrp/dgrp_specproc.c    |  7 +++++++
 drivers/staging/dgrp/dgrp_tty.c         | 10 ++++++++++
 drivers/tty/serial/8250/8250_hp300.c    | 20 ++++++++++----------
 drivers/tty/serial/Kconfig              |  4 ++--
 drivers/tty/serial/sccnxp.c             |  1 +
 include/linux/hsi/Kbuild                |  1 -
 include/linux/ratelimit.h               | 27 +++++++++------------------
 include/uapi/linux/hsi/Kbuild           |  1 +
 include/{ => uapi}/linux/hsi/hsi_char.h |  0
 net/irda/ircomm/ircomm_tty.c            |  2 ++
 11 files changed, 43 insertions(+), 31 deletions(-)
 rename include/{ => uapi}/linux/hsi/hsi_char.h (100%)
