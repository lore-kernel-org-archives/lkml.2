Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0DWV23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:28:29 -0400
Received: from tex.lwn.net ([70.33.254.29]:50529 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0DWV20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:26 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [RFC] Second OLPC Viafb series
Date: Fri, 23 Apr 2010 15:28:00 -0600
Message-Id: <1272058093-20914-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is the second series of viafb patches - the stuff that I was really
working toward since the beginning.  They depend on the previously-posted
first series.  What's added here is a big refactoring of the driver to
split its functions apart and the addition of code for GPIO, interrupt,
DMA, and camera management.

Florian, I incorporated your indexed port I/O patch, since it was an
obvious improvement and I was reworking that stuff anyway.

Note that the camera driver (the last in the series) is not yet ready for
submission; I add it here for completeness.

The full series of patches can be pulled from:

	git://git.lwn.net/linux-2.6.git viafb-posted

Some of this stuff is disruptive, and I only have one machine to test it
all on, so I'd really appreciate it if folks with other types of hardware
could try them out.

Florian Tobias Schandinat (1):
      viafb: package often used basic io functions

Jonathan Corbet (12):
      viafb: Move core stuff into via-core.c
      viafb: Separate global and fb-specific data
      viafb: add a driver for GPIO lines
      viafb: Convert GPIO and i2c to the new indexed port ops
      viafb: Turn GPIO and i2c into proper platform devices
      via: Do not attempt I/O on inactive I2C adapters
      viafb: Introduce viafb_find_i2c_adapter()
      via: Rationalize vt1636 detection
      viafb: Add a simple interrupt management infrastructure
      viafb: Add a simple VX855 DMA engine driver
      viafb: Reserve framebuffer memory for the upcoming camera driver
      viafb: Add a driver for the video capture engine

 drivers/video/Kconfig           |   12 
 drivers/video/via/Makefile      |    7 
 drivers/video/via/accel.c       |   30 
 drivers/video/via/dvi.c         |    6 
 drivers/video/via/global.c      |    2 
 drivers/video/via/global.h      |    1 
 drivers/video/via/hw.c          |  152 ----
 drivers/video/via/hw.h          |   12 
 drivers/video/via/lcd.c         |   12 
 drivers/video/via/via-camera.c  | 1399 ++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/via-camera.h  |   93 ++
 drivers/video/via/via-core.c    |  641 ++++++++++++++++++
 drivers/video/via/via-core.h    |  173 ++++
 drivers/video/via/via-gpio.c    |  289 ++++++++
 drivers/video/via/via-gpio.h    |   12 
 drivers/video/via/via_i2c.c     |  159 +++-
 drivers/video/via/via_i2c.h     |   25 
 drivers/video/via/via_io.h      |   58 +
 drivers/video/via/viafbdev.c    |  101 --
 drivers/video/via/viafbdev.h    |    9 
 drivers/video/via/vt1636.c      |   22 
 include/media/v4l2-chip-ident.h |    4 
 22 files changed, 2881 insertions(+), 338 deletions(-)

Thanks,

jon


