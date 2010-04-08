Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0DHRQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:16:48 -0400
Received: from tex.lwn.net ([70.33.254.29]:46456 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653Ab0DHRQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:44 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [RFC] Initial OLPC Viafb merge
Date: Thu,  8 Apr 2010 11:15:30 -0600
Message-Id: <1270746946-12467-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are the beginning of an effort to move work done for
the OLPC XO 1.5 machine into the mainline.  What's here is basic support
for the VX855 chipset, I2C, suspend/resume, and the OLPC panel display.
What's coming in the future is a reworking of the viafb driver into
something resembling a proper multifunction device, GPIO support, and
camera support.  But I'd like to start here.

If there's no objections, I'll start a tree and get it into linux-next in
the near future, with an eye toward a 2.6.35 merge.

Thanks,

jon

Chris Ball (2):
      viafb: Add 1200x900 DCON/LCD panel modes for OLPC XO-1.5
      viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5

Deepak Saxena (3):
      Minimal support for viafb suspend/resume
      VIAFB: Update suspend/resume to selectively restore registers
      Remove cursor restore hack in viafb

Harald Welte (4):
      [FB] viafb: Fix various resource leaks during module_init()
      viafb: use proper pci config API
      viafb: Determine type of 2D engine and store it in chip_info
      viafb: rework the I2C support in the VIA framebuffer driver

Jonathan Corbet (5):
      viafb: Unmap the frame buffer on initialization error
      viafb: Retain GEMODE reserved bits
      viafb: complete support for VX800/VX855 accelerated framebuffer
      viafb: rework suspend/resume
      viafb: Only suspend/resume on VX855

Paul Fox (2):
      suppress verbose debug messages:  change printk() to DEBUG_MSG()
      fix register save count, so it matches the restore count.

 drivers/video/via/accel.c    |   87 ++++++++++++++-----
 drivers/video/via/accel.h    |   40 +++++++++
 drivers/video/via/chip.h     |    8 +
 drivers/video/via/dvi.c      |   35 +++----
 drivers/video/via/hw.c       |   84 +++++++++++++-----
 drivers/video/via/hw.h       |    4 
 drivers/video/via/ioctl.h    |    2 
 drivers/video/via/lcd.c      |   29 ++++--
 drivers/video/via/lcd.h      |    2 
 drivers/video/via/share.h    |    8 +
 drivers/video/via/via_i2c.c  |  172 ++++++++++++++++++++++++--------------
 drivers/video/via/via_i2c.h  |   43 ++++++---
 drivers/video/via/viafbdev.c |  191 +++++++++++++++++++++++++++++++++++++++----
 drivers/video/via/viafbdev.h |    5 -
 drivers/video/via/viamode.c  |   14 +++
 drivers/video/via/vt1636.c   |   36 +++-----
 drivers/video/via/vt1636.h   |    2 
 17 files changed, 568 insertions(+), 194 deletions(-)
