Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0HYWQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60875 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0HYWQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:10 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 00/11] staging: tidspbridge: Remove services directory
Date: Wed, 25 Aug 2010 17:08:53 -0500
Message-Id: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the functions defined in the files of the services directory are
already implemented in the kernel. Other functions are only wrappers or
just do a simple thing, such as reading or assigning a value.

Ivan Gomez Castellanos (11):
  staging: tidspbridge: Move sync.c from services to core
  staging: tidspbridge: Remove ntfy.c
  staging: tidspbridge: Remove cfg_get_auto_start()
  staging: tidspbridge: Remove cfg_init() and cfg_exit()
  staging: tidspbridge: Remove cfg_get_dev_object() and do a trivial
    cleanup
  staging: tidspbridge: Remove cfg_get_exec_file()
  staging: tidspbridge: Remove cfg_get_object()
  staging: tidspbridge: Remove cfg_set_dev_object()
  staging: tidspbridge: Remove cfg_set_object()
  staging: tidspbridge: Remove cfg.c and cfg.h files
  staging: tidspbridge: Remove services.c and services.h

 drivers/staging/tidspbridge/Makefile               |    4 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |    1 -
 drivers/staging/tidspbridge/core/dsp-clock.c       |    1 -
 drivers/staging/tidspbridge/core/io_sm.c           |    1 -
 .../staging/tidspbridge/{services => core}/sync.c  |   17 ++
 drivers/staging/tidspbridge/core/tiomap3430.c      |    1 -
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |    1 -
 .../staging/tidspbridge/include/dspbridge/cfg.h    |  222 -----------------
 .../tidspbridge/include/dspbridge/services.h       |   50 ----
 drivers/staging/tidspbridge/pmgr/chnl.c            |    1 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |    1 -
 drivers/staging/tidspbridge/pmgr/dev.c             |   69 ++++--
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   12 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    3 -
 drivers/staging/tidspbridge/rmgr/drv.c             |   59 ++++-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   14 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |   12 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |   52 ++++-
 drivers/staging/tidspbridge/rmgr/node.c            |    1 -
 drivers/staging/tidspbridge/rmgr/proc.c            |   48 +++-
 drivers/staging/tidspbridge/rmgr/strm.c            |    1 -
 drivers/staging/tidspbridge/services/cfg.c         |  253 --------------------
 drivers/staging/tidspbridge/services/ntfy.c        |   31 ---
 drivers/staging/tidspbridge/services/services.c    |   70 ------
 25 files changed, 210 insertions(+), 719 deletions(-)
 rename drivers/staging/tidspbridge/{services => core}/sync.c (85%)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfg.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/services.h
 delete mode 100644 drivers/staging/tidspbridge/services/cfg.c
 delete mode 100644 drivers/staging/tidspbridge/services/ntfy.c
 delete mode 100644 drivers/staging/tidspbridge/services/services.c

