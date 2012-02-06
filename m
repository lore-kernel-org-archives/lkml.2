Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2BFXj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:39:57 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:57098 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2BFXjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:39:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EADRkME9bdWOb/2dsb2JhbABDhQurP4IcDwEjIzUCGA4COwMhAYgRBqZBkieBL4lwDwEFAgICCAEBBA0EBgELCQgUg0peFYJCgRYElSiFWI0E
X-IronPort-AV: E=Sophos;i="4.73,373,1325458800"; 
   d="scan'208";a="473049153"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/4] staging: tidspbridge: remove desgin-by-contract macros
Date: Tue,  7 Feb 2012 00:39:33 +0100
Message-Id: <cover.1328563908.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches removes all the design-by-contract (DBC) macros in the
tidspbridge.

Also it removes the config option CONFIG_TIDSPBRIDGE_DEBUG.

The patches are applied above these submitted patches:
http://thread.gmane.org/gmane.linux.kernel/1246081

The main reasons to remove these DBC macros are

* The kernel in general doesn't follow the DBC approach

* They only provide a needless verbosity, since they are available only
  when CONFIG_TIDSPBRIDGE_DEBUG is enabled. If they were useful they
  should be left for the dynamic debugging always. So, if they are not
  used, is dead code at the end, and should be removed.

* Deleting them means less code to maintain

As the Emperor Joseph II told to Mozart in the motion picture Amadeus:
"It's quality work. And there are simply too many notes, that's
all. Just cut a few and it will be perfect."

vmjl


Víctor Manuel Jáquez Leal (4):
  staging: tidspbridge: remove DBC_ENSURE and DBC_REQUIRED
  staging: tidspbridge: remove DBC_ASSERT macro
  staging: tidspbridge: remove dbc.h
  staging: tidspbridge: remove CONFIG_TIDSPBRIDGE_DEBUG

 drivers/staging/tidspbridge/Kconfig                |    6 -
 drivers/staging/tidspbridge/core/chnl_sm.c         |   34 +-----
 drivers/staging/tidspbridge/core/dsp-clock.c       |    3 -
 drivers/staging/tidspbridge/core/io_sm.c           |   29 +----
 drivers/staging/tidspbridge/core/msg_sm.c          |    3 -
 drivers/staging/tidspbridge/core/tiomap3430.c      |    9 --
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    1 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |   18 ---
 drivers/staging/tidspbridge/gen/uuidutil.c         |    7 -
 .../staging/tidspbridge/include/dspbridge/dbc.h    |   46 -------
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |    2 -
 drivers/staging/tidspbridge/pmgr/chnl.c            |   19 ---
 drivers/staging/tidspbridge/pmgr/cmm.c             |   68 +----------
 drivers/staging/tidspbridge/pmgr/cod.c             |   74 -----------
 drivers/staging/tidspbridge/pmgr/dbll.c            |  113 +-----------------
 drivers/staging/tidspbridge/pmgr/dev.c             |  132 --------------------
 drivers/staging/tidspbridge/pmgr/dmm.c             |   14 --
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    7 -
 drivers/staging/tidspbridge/pmgr/io.c              |   17 ---
 drivers/staging/tidspbridge/pmgr/msg.c             |   17 ---
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   88 -------------
 drivers/staging/tidspbridge/rmgr/disp.c            |   44 -------
 drivers/staging/tidspbridge/rmgr/drv.c             |   48 -------
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    6 -
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    5 -
 drivers/staging/tidspbridge/rmgr/mgr.c             |   36 ------
 drivers/staging/tidspbridge/rmgr/nldr.c            |   71 -----------
 drivers/staging/tidspbridge/rmgr/node.c            |   98 ---------------
 drivers/staging/tidspbridge/rmgr/proc.c            |   91 --------------
 drivers/staging/tidspbridge/rmgr/rmm.c             |   36 ------
 drivers/staging/tidspbridge/rmgr/strm.c            |   86 +-------------
 31 files changed, 11 insertions(+), 1217 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbc.h

-- 
1.7.8.3

