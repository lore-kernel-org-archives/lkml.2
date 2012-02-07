Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2BGA2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:28:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45583 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756034Ab2BGA2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:28:19 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+4PvRENKu4dl6PhQ5O95BYZrBuCmhJsWb78ljnd3
	1A8BQ9SKV7UoA5
Message-ID: <4F307015.4030608@gmx.de>
Date: Tue, 07 Feb 2012 00:28:05 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the changes below.
The key has not been signed yet as I didn't have time to take care about it.


Thanks,

Florian Tobias Schandinat


The following changes since commit f787f32e67e00b072f46b2ae3c454d2c0a1fcdb7:

  module_param: make bool parameters really bool (drivers/video/i810)
(2012-01-12 23:28:59 +0000)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.3-1

for you to fetch changes up to 9f1065032ceb7e86c7c9f16bb86518857e88a172:

  atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume (2012-01-28 19:50:22
+0000)

----------------------------------------------------------------
fbdev fixes for 3.3

It includes:
- a compile fix for fsl-diu-fb

- a fix for a suspend/resume issue in atmel_lcdfb

- a fix for a suspend/resume issue in OMAP

- a workaround for a hardware bug to avoid physical damage in OMAP

- a really trivial dead code removal in intelfb

----------------------------------------------------------------
Dan Carpenter (1):
      intelfb: remove some dead code

Florian Tobias Schandinat (1):
      Merge branch 'for-3.3-rc' of git://gitorious.org/linux-omap-dss2/linux
into fbdev-for-linus

Hubert Feurstein (1):
      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume

Michael Neuling (1):
      drivers/video: compile fixes for fsl-diu-fb.c

Tomi Valkeinen (7):
      OMAPDSS: use sync versions of pm_runtime_put
      OMAP: 4430SDP/Panda: use gpio_free_array to free HDMI gpios
      OMAP: 4430SDP/Panda: rename HPD GPIO to CT_CP_HPD
      OMAPDSS: remove wrong HDMI HPD muxing
      OMAP: 4430SDP/Panda: setup HDMI GPIO muxes
      OMAP: 4430SDP/Panda: add HDMI HPD gpio
      OMAPDSS: HDMI: PHY burnout fix

 arch/arm/mach-omap2/board-4430sdp.c       |   18 ++++++--
 arch/arm/mach-omap2/board-omap4panda.c    |   18 ++++++--
 arch/arm/mach-omap2/display.c             |    4 --
 drivers/video/atmel_lcdfb.c               |    2 +-
 drivers/video/fsl-diu-fb.c                |    4 +-
 drivers/video/intelfb/intelfbdrv.c        |    1 -
 drivers/video/omap2/dss/dispc.c           |    2 +-
 drivers/video/omap2/dss/dsi.c             |    2 +-
 drivers/video/omap2/dss/dss.c             |    2 +-
 drivers/video/omap2/dss/hdmi.c            |    5 ++-
 drivers/video/omap2/dss/rfbi.c            |    2 +-
 drivers/video/omap2/dss/ti_hdmi.h         |    4 ++
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c |   68 +++++++++++++++++++++++++++--
 drivers/video/omap2/dss/venc.c            |    2 +-
 include/video/omapdss.h                   |    5 ++
 15 files changed, 113 insertions(+), 26 deletions(-)
