Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab2EDU5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:57:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42837 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab2EDUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:06 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V4 0/5] [Media] Radio: Fixes and New features for FM
Date: Fri, 4 May 2012 15:48:57 -0500
Message-ID: <1336164542-11014-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

Mauro and the list,

This version 4 of patchset resolves the comments received from
Han's on patchset v3.

This patchset creates new control class 'V4L2_CTRL_CLASS_FM_RX' for FM RX,
introduces 2 new CID's for FM RX and and 1 new CID for FM TX. Also adds 1
field in struct v4l2_hw_freq_seek.

This patch adds few new features to TI's FM driver features
are listed below,

1) FM TX RDS Support (RT, PS, AF, PI, PTY)
2) FM RX Russian band support
3) FM RX AF set/get
4) FM RX De-emphasis mode set/get

Along with new features this patch also fixes few issues in the driver
like default rssi level for seek, unnecessory logs etc.

Manjunatha Halli (5):
  WL128x: Add support for FM TX RDS
  New control class and features for FM RX
  Add new CID for FM TX RDS Alternate Frequency
  Media: Update docs for V4L2 FM new features
  WL12xx: Add support for FM new features.

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   77 +++++++++++
 Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   35 +++++-
 drivers/media/radio/wl128x/fmdrv.h                 |    3 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   55 ++++++--
 drivers/media/radio/wl128x/fmdrv_common.h          |   43 +++++-
 drivers/media/radio/wl128x/fmdrv_rx.c              |   92 ++++++++++---
 drivers/media/radio/wl128x/fmdrv_rx.h              |    2 +-
 drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++----
 drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |  138 +++++++++++++++++++-
 drivers/media/video/v4l2-ctrls.c                   |   18 ++-
 include/linux/videodev2.h                          |   20 +++-
 15 files changed, 462 insertions(+), 80 deletions(-)

-- 
1.7.4.1

