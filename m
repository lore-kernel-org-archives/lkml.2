Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2GZRsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:48:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55496 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2GZRsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:48:14 -0400
Date: Thu, 26 Jul 2012 10:48:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc patches for 3.6-rc1
Message-ID: <20120726174810.GB29539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.6-rc1

for you to fetch changes up to 6078188e2ba1d61a2119ddb2289e88c2c2a015ab:

  mei: use module_pci_driver (2012-07-19 15:33:30 -0700)

----------------------------------------------------------------
CHAR/MISC patches for 3.6-rc1

Here's the "big" pull request for 3.6-rc1 for the char/misc drivers.

It's really just a few updates to the mei driver, plus 4 other tiny patches,
nothing big at all.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexandre Pereira da Silva (1):
      misc: at25: Parse dt settings

Camuso, Tony (1):
      misc: hpilo: increase number of max supported channels

Devendra Naga (1):
      powerpc/BSR: cleanup the error path of bsr_init

Greg Kroah-Hartman (1):
      Merge 3.5-rc7 into char-misc-next.

Tomas Winkler (14):
      mei: mei.txt: minor grammar fixes
      mei: check for error codes that mei_flow_ctrl_creds retuns
      mei: make mei_write_message more readable
      mei: mei_irq_thread_write_handler check for overflow
      mei: group wd_interface_reg with watchdog variables within struct mei_device
      mei: don't query HCSR for host buffer depth
      mei: revamp host buffer interface function
      mei: mei_device can be const for mei register access functions
      mei: remove write only wariable wd_due_counter
      mei: mei_wd_host_init: update the comment
      mei: introduce mei_data2slots wrapper
      mei: streamline the _mei_irq_thread_close/ioctol functions
      mei: mei_irq_thread_write_handler - line break fix
      mei: use module_pci_driver

 Documentation/devicetree/bindings/misc/at25.txt |   21 +++
 Documentation/misc-devices/mei/mei.txt          |   14 +-
 drivers/char/bsr.c                              |    6 +-
 drivers/misc/eeprom/at25.c                      |   61 +++++---
 drivers/misc/hpilo.c                            |   33 +++--
 drivers/misc/hpilo.h                            |    4 +-
 drivers/misc/mei/init.c                         |    4 +-
 drivers/misc/mei/interface.c                    |   85 +++++-------
 drivers/misc/mei/interface.h                    |   18 ++-
 drivers/misc/mei/interrupt.c                    |  169 ++++++++++-------------
 drivers/misc/mei/iorw.c                         |    8 +-
 drivers/misc/mei/main.c                         |   48 +------
 drivers/misc/mei/mei_dev.h                      |   24 ++--
 drivers/misc/mei/wd.c                           |    6 +-
 14 files changed, 242 insertions(+), 259 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/at25.txt
