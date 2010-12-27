Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0L0OW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:22:29 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34126 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0L0OW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:22:28 -0500
Date: Mon, 27 Dec 2010 23:20:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.37-rc8
Message-ID: <20101227142046.GD16946@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly straightforward set of bugfixes and regression fixes.

When the SH-Mobile driver underwent some rework the userspace-facing var
info ceased propagating accurate mode information to userspace tools,
which is now corrected. A further patch for the LCDC fixes up bounding
for invalid mode settings that was triggered on older platforms, which
previously had a working fbcon but broken application interface.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Dave Airlie (1):
      fb: fix overlapping test off-by-one.

Fabio Estevam (1):
      video: imxfb: Fix the maximum value for yres

Guennadi Liakhovetski (3):
      fbdev: sh-mobile: restore display size configuration
      fbdev: sh-mobile: retrieve and propagate display sizes from EDID
      fbdev: sh_mobile_lcdc: increase maximum framebuffer size to support 1080p

 drivers/video/fbmem.c            |    2 +-
 drivers/video/imxfb.c            |    9 +++------
 drivers/video/sh_mobile_hdmi.c   |   16 +++++++++++++---
 drivers/video/sh_mobile_lcdcfb.c |   30 +++++++++++-------------------
 4 files changed, 28 insertions(+), 29 deletions(-)
