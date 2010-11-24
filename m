Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab0KXHiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:38:54 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46854 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0KXHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:38:50 -0500
Date: Wed, 24 Nov 2010 16:38:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.37-rc4
Message-ID: <20101124073803.GI11705@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically just a random mix of bugfixes and tidying. These
changes look a bit more invasive than they actually are, mostly due to
dead code removal in the sisfb driver (which has no functional changes)
and an fbcmap bugfix layered on top of some Lindent/whitespace churn.

I've applied the sisfb changes last. If you'd rather I carry those over
for .38, I'll prepare another pull request.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Aaro Koskinen (9):
      sisfb: delete obsolete PCI ROM bug workaround
      sisfb: delete fallback code for pci_map_rom()
      sisfb: delete dead SIS_XORG_XF86 code
      sisfb: delete redudant #define SIS_LINUX_KERNEL
      sisfb: use CONFIG_FB_SIS_301/315 instead of SIS301/315H
      sisfb: remove InPort/OutPort wrappers
      sisfb: replace SiS_SetMemory with memset_io
      sisfb: move the CONFIG warning to sis_main.c
      sisfb: delete osdef.h

Arnd Hannemann (1):
      fbdev: sh_mobile_lcdcfb: fix bug in reconfig()

Dan Carpenter (2):
      fbcmap: cleanup white space in fb_alloc_cmap()
      fbcmap: integer overflow bug

Daniel Drake (1):
      lxfb: Program panel v/h sync output polarity correctly

Mike Frysinger (1):
      fbdev: da8xx: punt duplicated FBIO_WAITFORVSYNC define

Paul Mundt (1):
      MAINTAINERS: Add fbdev patchwork entry, tidy up file patterns.

Vicente Jimenez Aguilar (1):
      fbdev: Update documentation index file.

 Documentation/fb/00-INDEX        |   32 ++-
 MAINTAINERS                      |    4 +-
 drivers/video/fbcmap.c           |   66 +++--
 drivers/video/geode/lxfb_ops.c   |    4 +-
 drivers/video/sh_mobile_lcdcfb.c |    4 +-
 drivers/video/sis/init.c         |  685 +++-----------------------------------
 drivers/video/sis/init.h         |   63 +----
 drivers/video/sis/init301.c      |  467 ++++++++------------------
 drivers/video/sis/init301.h      |   43 +--
 drivers/video/sis/initextlfb.c   |    7 +-
 drivers/video/sis/osdef.h        |  133 --------
 drivers/video/sis/sis.h          |    1 -
 drivers/video/sis/sis_main.c     |   30 +--
 drivers/video/sis/vgatypes.h     |   11 -
 drivers/video/sis/vstruct.h      |   12 -
 include/linux/fb.h               |    1 +
 include/video/da8xx-fb.h         |    1 -
 17 files changed, 284 insertions(+), 1280 deletions(-)
 delete mode 100644 drivers/video/sis/osdef.h
