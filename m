Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2DRQGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:06:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39402 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2DRQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:06:46 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <benzyg@ti.com>, <linux-kernel@vger.kernel.org>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH V2 0/5] [Media] Radio: Fixes and New features for FM
Date: Wed, 18 Apr 2012 11:06:38 -0500
Message-ID: <1334765203-31844-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

Mauro and the list,

This version 2 of patchset resolves the comments received from
Joonyoung Shim on patchset v1

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
  [Media] WL128x: Add support for FM TX RDS
  [Media] New control class and features for FM RX
  [Media] Add new CID for FM TX RDS Alternate Frequency
  [Documentation] Media: Update docs for V4L2 FM new features
  [Media] WL12xx: Add support for FM new features.

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   78 +++++++++++
 Documentation/DocBook/media/v4l/dev-rds.xml        |    5 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +
 drivers/media/radio/wl128x/fmdrv.h                 |    3 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |   55 ++++++--
 drivers/media/radio/wl128x/fmdrv_common.h          |   43 +++++-
 drivers/media/radio/wl128x/fmdrv_rx.c              |   92 ++++++++++---
 drivers/media/radio/wl128x/fmdrv_rx.h              |    2 +-
 drivers/media/radio/wl128x/fmdrv_tx.c              |   41 +++----
 drivers/media/radio/wl128x/fmdrv_tx.h              |    3 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |  138 +++++++++++++++++++-
 drivers/media/video/v4l2-ctrls.c                   |   18 +++
 include/linux/videodev2.h                          |   17 +++-
 14 files changed, 429 insertions(+), 76 deletions(-)

-- 
1.7.4.1

