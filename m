Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0LXI0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:26:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51194 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0LXI0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:26:48 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PULL] staging: tidspbridge for 2.6.38
Date: Fri, 24 Dec 2010 02:15:43 -0600
Message-Id: <1293178543-7556-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This is the first pull request of changes for tidspbridge driver for 2.6.38,
I expect to make another request with at least one bug fix, but in the mean
time here it is the content for this one:

The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:

  Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)

are available in the git repository at:
  git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git dspbridge

Armando Uribe (6):
      staging: tidspbridge - Eliminate direct manipulation of OMAP_SYSC_BASE
      staging: tidspbridge - Remove unused defined constants
      staging: tidspbridge - Remove unused functions
      staging: tidspbridge - Remove unused structs
      staging: tidspbridge - Remove unused typedefs
      staging: tidspbridge - Remove trivial header files

Felipe Contreras (1):
      staging: tidspbridge: fix mgr_enum_node_info

Guzman Lugo, Fernando (1):
      staging: tidspbridge - make sync_wait_on_event interruptible

Ionut Nicu (13):
      staging: tidspbridge: mgr_enum_node_info cleanup
      staging: tidspbridge: fix kernel oops in bridge_io_get_proc_load
      staging: tidspbridge: remove gs memory allocator
      staging: tidspbridge: remove utildefs
      staging: tidspbridge: switch to linux bitmap API
      staging: tidspbridge: remove gb bitmap implementation
      staging: tidspbridge: convert core to list_head
      staging: tidspbridge: convert pmgr to list_head
      staging: tidspbridge: convert rmgr to list_head
      staging: tidspbridge: remove custom linked list
      staging: tidspbridge: core code cleanup
      staging: tidspbridge: pmgr code cleanup
      staging: tidspbridge: rmgr/node.c code cleanup

Laurent Pinchart (1):
      staging: tidspbridge: Fix atoi to support hexadecimal numbers correctly

Omar Ramirez Luna (1):
      staging: tidspbridge: use the right type for list_is_last

Ramos Falcon, Ernesto (1):
      staging: tidspbridge: remove code referred by OPT_ZERO_COPY_LOADER

Sapiens, Rene (1):
      staging: tidspbridge: overwrite DSP error codes

 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/TODO                   |    1 -
 drivers/staging/tidspbridge/core/_msg_sm.h         |   12 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |  626 ++++++++----------
 drivers/staging/tidspbridge/core/dsp-clock.c       |   52 +--
 drivers/staging/tidspbridge/core/io_sm.c           |  348 ++++------
 drivers/staging/tidspbridge/core/msg_sm.c          |  605 +++++++----------
 drivers/staging/tidspbridge/core/tiomap3430.c      |    5 -
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 +-
 drivers/staging/tidspbridge/dynload/cload.c        |   60 +--
 drivers/staging/tidspbridge/gen/gb.c               |  166 -----
 drivers/staging/tidspbridge/gen/gh.c               |   38 +-
 drivers/staging/tidspbridge/gen/gs.c               |   88 ---
 .../tidspbridge/include/dspbridge/_chnl_sm.h       |    8 +-
 .../tidspbridge/include/dspbridge/brddefs.h        |    2 -
 .../tidspbridge/include/dspbridge/cfgdefs.h        |   20 -
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   21 -
 .../tidspbridge/include/dspbridge/chnldefs.h       |    3 -
 .../tidspbridge/include/dspbridge/chnlpriv.h       |   13 -
 .../tidspbridge/include/dspbridge/cmmdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/cod.h    |   13 +-
 .../staging/tidspbridge/include/dspbridge/dbdefs.h |   26 -
 .../tidspbridge/include/dspbridge/dbldefs.h        |  141 ----
 .../staging/tidspbridge/include/dspbridge/dbll.h   |    6 -
 .../tidspbridge/include/dspbridge/dblldefs.h       |   65 --
 .../tidspbridge/include/dspbridge/dehdefs.h        |   32 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   59 +--
 .../staging/tidspbridge/include/dspbridge/disp.h   |   15 +-
 .../tidspbridge/include/dspbridge/dispdefs.h       |   35 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |   34 +-
 .../tidspbridge/include/dspbridge/drvdefs.h        |   25 -
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    8 -
 .../tidspbridge/include/dspbridge/dspdefs.h        |   10 +-
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |    2 -
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    4 +-
 .../tidspbridge/include/dspbridge/dspioctl.h       |    5 -
 .../tidspbridge/include/dspbridge/dynamic_loader.h |    2 -
 drivers/staging/tidspbridge/include/dspbridge/gb.h |   79 ---
 drivers/staging/tidspbridge/include/dspbridge/gs.h |   59 --
 .../tidspbridge/include/dspbridge/host_os.h        |    9 -
 drivers/staging/tidspbridge/include/dspbridge/io.h |   29 +-
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |  143 +----
 .../staging/tidspbridge/include/dspbridge/iodefs.h |   36 -
 .../staging/tidspbridge/include/dspbridge/ldr.h    |   29 -
 .../staging/tidspbridge/include/dspbridge/list.h   |  225 ------
 .../staging/tidspbridge/include/dspbridge/mbx_sh.h |   40 --
 .../staging/tidspbridge/include/dspbridge/node.h   |   20 +-
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 +-
 .../staging/tidspbridge/include/dspbridge/pwr_sh.h |   33 -
 .../include/dspbridge/resourcecleanup.h            |   11 -
 .../staging/tidspbridge/include/dspbridge/rms_sh.h |    9 -
 .../staging/tidspbridge/include/dspbridge/strm.h   |   62 --
 .../tidspbridge/include/dspbridge/strmdefs.h       |    2 -
 .../staging/tidspbridge/include/dspbridge/sync.h   |   14 +-
 .../tidspbridge/include/dspbridge/utildefs.h       |   39 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |  535 ++++++---------
 drivers/staging/tidspbridge/pmgr/cod.c             |   14 +-
 drivers/staging/tidspbridge/pmgr/dbll.c            |   41 --
 drivers/staging/tidspbridge/pmgr/dev.c             |   87 +--
 drivers/staging/tidspbridge/pmgr/io.c              |    1 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    8 +-
 drivers/staging/tidspbridge/rmgr/disp.c            |   44 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |  116 +---
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    1 -
 drivers/staging/tidspbridge/rmgr/mgr.c             |   50 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    3 -
 drivers/staging/tidspbridge/rmgr/node.c            |  724 +++++++++-----------
 drivers/staging/tidspbridge/rmgr/proc.c            |    2 -
 drivers/staging/tidspbridge/rmgr/rmm.c             |   75 +--
 69 files changed, 1421 insertions(+), 3684 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/gen/gb.c
 delete mode 100644 drivers/staging/tidspbridge/gen/gs.c
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dbldefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dehdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dispdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/drvdefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/gb.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/gs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/iodefs.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/ldr.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/list.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/pwr_sh.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/utildefs.h

Regards,

Omar
