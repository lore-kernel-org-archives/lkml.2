Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0CSPNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:13:46 -0400
Received: from kroah.org ([198.145.64.141]:51545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0CSPNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:13:32 -0400
Date: Fri, 19 Mar 2010 08:13:26 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] TTY fixes for 2.6.34-git
Message-ID: <20100319151326.GC8541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some tty bugfixes for your 2.6.34-git tree.

The biggest here is a revert of a patch that went into 2.6.34-rc1 that
shouldn't have gone in (no proper testing and no userspace need just
yet.)  Other than that, just a number of bugfixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/tty-2.6.git/

These patches have been in the linux-next tree for a while now.

Patches will be sent to the linux-kernel mailing list, if anyone wants
to see them.

thanks,

greg k-h

------------

 drivers/char/hvc_console.c              |   31 ++++++++++++++++--------
 drivers/char/tty_buffer.c               |    4 +-
 drivers/char/tty_port.c                 |    2 +-
 drivers/char/vt_ioctl.c                 |   39 +++++++++++++++----------------
 drivers/serial/cpm_uart/cpm_uart_cpm2.c |    4 +-
 drivers/serial/uartlite.c               |   10 ++++----
 drivers/usb/serial/console.c            |    1 +
 include/linux/tty.h                     |   10 ++++---
 include/linux/vt.h                      |    3 +-
 9 files changed, 58 insertions(+), 46 deletions(-)

---------------

Amit Shah (1):
      hvc_console: Fix race between hvc_close and hvc_remove

David Miller (1):
      uartlite: Fix build on sparc.

Fang Wenqi (1):
      tty_buffer: Fix distinct type warning

Greg Kroah-Hartman (1):
      Revert "tty: Add a new VT mode which is like VT_PROCESS but doesn't require a VT_RELDISP ioctl call"

Jason Wessel (1):
      tty_port,usb-console: Fix usb serial console open/close regression

Mel Gorman (1):
      tty: Take a 256 byte padding into account when buffering below sub-page units

Tobias Klauser (1):
      tty: cpm_uart: use resource_size()

