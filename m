Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab2JZRSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:18:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:59948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab2JZRR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:17:58 -0400
Date: Fri, 26 Oct 2012 10:15:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc changes for 3.7-rc3
Message-ID: <20121026171500.GA11293@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6f0c0580b70c89094b3422ba81118c7b959c7556:

  Linux 3.7-rc2 (2012-10-20 12:11:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.7-rc3

for you to fetch changes up to 2cb55a2f47a3c695a0105b7fc04a3b70c3bc4e4f:

  sonypi: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP (2012-10-25 12:05:50 -0700)

----------------------------------------------------------------
Char/misc driver fixes for 3.7-rc3

Here are some driver fixes for 3.7.  They include extcon driver fixes, a
hyper-v bugfix, and two other minor driver fixes.

All of these have been in the linux-next releases for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (4):
      extcon: adc-jack: Fix checking return value of request_any_context_irq
      extcon: adc-jack: Add missing MODULE_LICENSE
      extcon: Fix kerneldoc for extcon_set_cable_state and extcon_set_cable_state_
      extcon: max77693: Use max77693_update_reg for rmw operations

Chanwoo Choi (1):
      extcon: MAX77693: Add platform data for MUIC device to initialize registers

Devendra Naga (1):
      extcon-max8997: remove usage of ret in max8997_muic_handle_charger_type_detach

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-3.7' of git://git.kernel.org/.../mzx/extcon into char-misc-linus

Jenny TC (1):
      extcon : register for cable interest by cable name

K. Y. Srinivasan (1):
      Drivers: hv: Cleanup error handling in vmbus_open()

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Sachin Kamat (2):
      extcon: Remove duplicate inclusion of extcon.h header file
      extcon: Fix return value in extcon_register_interest()

Yuanhan Liu (1):
      sonypi: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP

anish kumar (4):
      extcon: standard cable names definition and declaration changed
      extcon: optimising the check_mutually_exclusive function
      extcon: driver model release call not needed
      extcon: trivial: kfree missed from remove path

 drivers/char/sonypi.c            |   2 +-
 drivers/extcon/extcon-adc-jack.c |  10 +++++--
 drivers/extcon/extcon-class.c    | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 drivers/extcon/extcon-gpio.c     |   1 -
 drivers/extcon/extcon-max77693.c |  46 +++++++++++++++++++++++--------
 drivers/extcon/extcon-max8997.c  |   6 ++--
 drivers/hv/channel.c             |  24 ++++++++--------
 include/linux/extcon.h           |   2 +-
 include/linux/mfd/max77693.h     |  13 +++++++++
 9 files changed, 152 insertions(+), 94 deletions(-)
