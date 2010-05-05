Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0EEWfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:35:10 -0400
Received: from tex.lwn.net ([70.33.254.29]:50613 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0EEWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:35:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: [RFC] Third OLPC viafb patch series (camera driver)
Date: Wed,  5 May 2010 16:34:39 -0600
Message-Id: <1273098884-21848-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is, perhaps, the last set of viafb patches I'll send around before the
merge window.  This series completes the task of adding the via-camera
driver - in the correct spot, this time.  To that end, it has to reorganize
the viafb header files a bit.

V4L2 folks: only the final patch in this series really needs your
attention.  Note that it has no hope of appying or working without a long
series of predecessor patches; the full set, prior to this series, is
currently in linux-next.  If the driver is acceptable to you, I'd prefer to
merge it through my viafb tree to be sure all the prerequisites land in
mainline at the right time.

As usual, this series can be found at:

	git://git.lwn.net/linux-2.6.git viafb-posted

The camera driver has been cleaned up a bit since the last time around.
But the main thing I had to do was to make some of the header files
globally visible so I could put the camera driver with the rest of the V4L2
crowd.  This will also let us move the core, i2c, and gpio drivers to
drivers/mfd, should we want to in the future.

There shouldn't be any functionality changes beyond the new driver.

Comments?

Thanks,

jon

Jonathan Corbet (5):
      viafb: fold via_io.h into via-core.h
      viafb: get rid of i2c debug cruft
      viafb: Eliminate some global.h references
      viafb: move some include files to include/linux
      Add the viafb video capture driver

 b/drivers/media/video/Kconfig         |   10 
 b/drivers/media/video/Makefile        |    2 
 b/drivers/media/video/via-camera.c    | 1368 ++++++++++++++++++++++++++++++++++
 b/drivers/media/video/via-camera.h    |   93 ++
 b/drivers/video/via/accel.c           |    4 
 b/drivers/video/via/dvi.c             |    4 
 b/drivers/video/via/hw.c              |    3 
 b/drivers/video/via/hw.h              |    1 
 b/drivers/video/via/lcd.c             |    4 
 b/drivers/video/via/share.h           |   11 
 b/drivers/video/via/via-core.c        |   22 
 b/drivers/video/via/via-gpio.c        |    5 
 b/drivers/video/via/via_i2c.c         |   14 
 b/drivers/video/via/via_modesetting.c |    2 
 b/drivers/video/via/via_utility.c     |    1 
 b/drivers/video/via/viafbdev.c        |    4 
 b/drivers/video/via/viamode.c         |    1 
 b/drivers/video/via/vt1636.c          |    4 
 b/include/linux/via-core.h            |  221 +++++
 b/include/linux/via-gpio.h            |   14 
 b/include/linux/via_i2c.h             |   42 +
 b/include/media/v4l2-chip-ident.h     |    4 
 drivers/video/via/via-core.h          |  173 ----
 drivers/video/via/via-gpio.h          |   14 
 drivers/video/via/via_i2c.h           |   42 -
 drivers/video/via/via_io.h            |   67 -
 26 files changed, 1798 insertions(+), 332 deletions(-)


