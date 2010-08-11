Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0HKQlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:41:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47237 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0HKQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:41:17 -0400
Date: Wed, 11 Aug 2010 18:41:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.36
Message-ID: <20100811184108.639dd3d6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a first round of i2c subsystem updates for Linux 2.6.36
from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

The big thing here is the multiplexing support, with core support as
well as support for the popular NXP PCA954x family of multiplexers and
switches. It may have a few rough edges left, but overall should work.
The rest are small cleanups.

 Documentation/i2c/instantiating-devices   |    2 +-
 drivers/i2c/Kconfig                       |   13 ++
 drivers/i2c/Makefile                      |    3 +-
 drivers/i2c/i2c-core.c                    |  158 +++++++++++----
 drivers/i2c/i2c-dev.c                     |   66 +++++--
 drivers/i2c/i2c-mux.c                     |  165 ++++++++++++++++
 drivers/i2c/muxes/Kconfig                 |   18 ++
 drivers/i2c/muxes/Makefile                |    8 +
 drivers/i2c/muxes/pca954x.c               |  301 +++++++++++++++++++++++++++++
 drivers/macintosh/therm_windtunnel.c      |    4 +-
 drivers/media/video/bt8xx/bttv-i2c.c      |    2 +-
 drivers/media/video/cx18/cx18-i2c.c       |    3 +-
 drivers/media/video/cx23885/cx23885-i2c.c |   15 +-
 drivers/media/video/cx88/cx88-i2c.c       |   19 +--
 drivers/media/video/em28xx/em28xx-cards.c |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c       |    9 +-
 drivers/media/video/v4l2-common.c         |    3 +-
 drivers/usb/host/ohci-pnx4008.c           |    2 +-
 drivers/video/matrox/i2c-matroxfb.c       |    2 +-
 include/linux/i2c-mux.h                   |   46 +++++
 include/linux/i2c.h                       |   33 ++--
 include/linux/i2c/pca954x.h               |   47 +++++
 22 files changed, 805 insertions(+), 116 deletions(-)
 create mode 100644 drivers/i2c/i2c-mux.c
 create mode 100644 drivers/i2c/muxes/Kconfig
 create mode 100644 drivers/i2c/muxes/Makefile
 create mode 100644 drivers/i2c/muxes/pca954x.c
 create mode 100644 include/linux/i2c-mux.h
 create mode 100644 include/linux/i2c/pca954x.h

---------------

Jean Delvare (6):
      i2c: Add support for custom probe function
      V4L/DVB: Use custom I2C probing function mechanism
      i2c: Move adapter locking helpers to i2c-core
      i2c: Drop dummy variable
      i2c: Make i2c_default_probe self-sufficient
      i2c: Use a separate mutex for userspace client lists

Joe Perches (1):
      i2c-dev: Remove unnecessary kmalloc casts

Julia Lawall (1):
      i2c-dev: Use memdup_user

Michael Lawnick (2):
      i2c: Multiplexed I2C bus core support
      i2c: I2C bus multiplexer driver pca954x

Thanks,
-- 
Jean Delvare
