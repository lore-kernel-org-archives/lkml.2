Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0GLW4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56973 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab0GLW4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:24 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 00/11] staging: tidspbridge: header cleanup series
Date: Mon, 12 Jul 2010 17:55:58 -0500
Message-Id: <1278975369-7687-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series targetted to remove std.h, GlobalTypes.h and dbdefs.h. These
introduce custom types and macros which dont make sense for linux kernel

Nishanth Menon (11):
  staging: tidspbridge: remove custom TRUE FALSE
  staging: tidspbridge: no need for custom NULL
  staging: tidspbridge: remove std.h
  staging: tidspbridge: remove custom typedef reg_uword32
  staging: tidspbridge: remove RET_OK RET_FAIL
  staging: tidspbridge: remove GlobalTypes.h
  staging: tidspbridge: replace CONST with c standard const
  staging: tidspbridge: remove IN modifier
  staging: tidspbridge: remove OPTIONAL
  staging: tidspbridge: remove OUT define
  staging: tidspbridge: remove dbdefs.h

 drivers/staging/tidspbridge/core/_tiomap_pwr.h     |   14 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |   23 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    7 +-
 drivers/staging/tidspbridge/core/io_sm.c           |   28 +-
 drivers/staging/tidspbridge/core/msg_sm.c          |    8 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   64 ++---
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |  140 +++------
 drivers/staging/tidspbridge/core/tiomap_io.c       |    8 +-
 drivers/staging/tidspbridge/core/tiomap_io.h       |   14 +-
 drivers/staging/tidspbridge/core/wdt.c             |    2 +-
 drivers/staging/tidspbridge/dynload/cload.c        |    2 +-
 .../staging/tidspbridge/dynload/dload_internal.h   |    3 -
 drivers/staging/tidspbridge/dynload/header.h       |    6 -
 .../tidspbridge/dynload/tramp_table_c6000.c        |    2 +-
 drivers/staging/tidspbridge/gen/gb.c               |    4 +-
 drivers/staging/tidspbridge/gen/gh.c               |    2 +-
 drivers/staging/tidspbridge/gen/gs.c               |    2 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |    8 +-
 drivers/staging/tidspbridge/hw/GlobalTypes.h       |  308 --------------------
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |    1 -
 drivers/staging/tidspbridge/hw/hw_defs.h           |    2 -
 drivers/staging/tidspbridge/hw/hw_mmu.c            |   85 ++----
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   28 +-
 .../staging/tidspbridge/include/dspbridge/chnl.h   |    4 +-
 .../staging/tidspbridge/include/dspbridge/clk.h    |    4 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   14 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |   20 +-
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |   74 +++---
 .../tidspbridge/include/dspbridge/dbdcddef.h       |    6 +-
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |    2 -
 .../staging/tidspbridge/include/dspbridge/dbtype.h |   88 ------
 .../staging/tidspbridge/include/dspbridge/dev.h    |   46 ++--
 .../staging/tidspbridge/include/dspbridge/disp.h   |    8 +-
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    6 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |   16 +-
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    2 +-
 .../tidspbridge/include/dspbridge/dspchnl.h        |   16 +-
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 ++--
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |    2 +-
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    8 +-
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |    6 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 drivers/staging/tidspbridge/include/dspbridge/io.h |    4 +-
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |   10 +-
 .../staging/tidspbridge/include/dspbridge/mgr.h    |   16 +-
 .../staging/tidspbridge/include/dspbridge/msg.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/nldr.h   |   12 +-
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   10 +-
 .../staging/tidspbridge/include/dspbridge/node.h   |   40 ++--
 .../tidspbridge/include/dspbridge/nodepriv.h       |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |   18 +-
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 +-
 .../tidspbridge/include/dspbridge/rmstypes.h       |    4 -
 .../staging/tidspbridge/include/dspbridge/std.h    |   94 ------
 .../staging/tidspbridge/include/dspbridge/strm.h   |   22 +-
 .../tidspbridge/include/dspbridge/uuidutil.h       |    6 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |    6 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |   16 +-
 drivers/staging/tidspbridge/pmgr/cod.c             |   21 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |    6 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |   38 ++--
 drivers/staging/tidspbridge/pmgr/dmm.c             |   10 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    6 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    6 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |    4 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   94 +++---
 drivers/staging/tidspbridge/rmgr/disp.c            |   12 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |    8 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    4 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |   17 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |   25 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   52 ++--
 drivers/staging/tidspbridge/rmgr/proc.c            |   20 +-
 drivers/staging/tidspbridge/rmgr/pwr.c             |    8 +-
 drivers/staging/tidspbridge/rmgr/rmm.c             |    3 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |   21 +-
 drivers/staging/tidspbridge/services/cfg.c         |   11 +-
 drivers/staging/tidspbridge/services/services.c    |    3 +-
 79 files changed, 587 insertions(+), 1182 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/hw/GlobalTypes.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbtype.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/std.h

 Regards,
 Nishanth Menon
