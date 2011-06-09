Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1FIRQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:16:06 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36827 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab1FIRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:16:01 -0400
X-Sasl-enc: qbvR+oLg+ckBVdn/GqEyi55zDmSfsWTv3L65XYvbfH7D 1307639760
Date: Thu, 9 Jun 2011 10:15:51 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING fixes for 3.0
Message-ID: <20110609171551.GA32041@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of minor staging driver fixes for your 3.0 tree.

Nothing major, lots of little things.  The non-drivers/staging fix is to
resolve a problem of a driver outside of the staging tree including a
staging include file that had accidentally got added to
include/staging/.  That has been fixed, and the driver will be updated
in 3.1 to do things "correctly" allowing the staging driver to move out
into the proper media directory.

I've also removed the STAGING_EXCLUDE_BUILD Kconfig option to make it
easier for people to build the staging tree, as we discussed at LinuxCon
a few weeks ago.  This has already turned up some "interesting" build
results in the linux-next tree that were previously unknown :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-linus

These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------

 drivers/media/video/cx23885/cx23885-cards.c        |    2 +-
 drivers/staging/Kconfig                            |   18 -----------------
 drivers/staging/altera-stapl/altera-jtag.c         |    2 +-
 drivers/staging/altera-stapl/altera.c              |    2 +-
 .../staging/altera-stapl}/altera.h                 |    0
 drivers/staging/ath6kl/Kconfig                     |    1 +
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    3 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 -
 drivers/staging/gma500/psb_drv.c                   |   15 +++++++++++++-
 drivers/staging/gma500/psb_fb.c                    |   10 +++++++++
 drivers/staging/gma500/psb_intel_bios.c            |   13 ++++++++---
 drivers/staging/iio/dac/max517.c                   |    2 +-
 drivers/staging/iio/imu/adis16400_ring.c           |   10 ++++++--
 drivers/staging/iio/industrialio-trigger.c         |    1 +
 drivers/staging/mei/init.c                         |    4 +-
 drivers/staging/olpc_dcon/Kconfig                  |    1 +
 drivers/staging/rts_pstor/sd.c                     |    2 +-
 drivers/staging/usbip/stub_dev.c                   |   21 ++++++++++++++++++++
 drivers/staging/usbip/stub_rx.c                    |   20 ++++++++++--------
 19 files changed, 84 insertions(+), 45 deletions(-)
 rename {include/staging => drivers/staging/altera-stapl}/altera.h (100%)

---------------

Andre Bartke (1):
      staging: iio: error case memory leak fix

Arjan Mels (1):
      staging: usbip: bugfix prevent driver unbind

Dan Carpenter (1):
      Staging: mei: fix debug code

Greg Kroah-Hartman (3):
      Staging: altera: move .h file to proper place
      Staging: remove STAGING_EXCLUDE_BUILD option
      Staging: cx23885: fix include of altera.h

Michael Chang (1):
      staging: gma500: get control from firmware framebuffer if conflicts

Michael Hennerich (1):
      staging: iio: industrialio-trigger: set iio_poll_func private_data

Nicolas Kaiser (1):
      staging: rts_pstor: use bitwise operator instead of logical one

Patrik Jakobsson (1):
      staging: gma500: Skip bogus LVDS VBT mode and check for LVDS before adding backlight

Randy Dunlap (2):
      staging: fix olpc_dcon build, needs BACKLIGHT_CLASS_DEVICE
      staging: fix ath6kl build when CFG80211 is not enabled

Roland Stigge (1):
      staging: iio: max517: Fix iio_info changes

Roland Vossen (1):
      staging: brcm80211: fix for 'multiple definition of wl_msg_level' build err

Vasanthakumar Thiagarajan (1):
      staging: ath6kl: Fix a kernel panic during suspend/resume

