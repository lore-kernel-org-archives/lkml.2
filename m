Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab2CIAFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:02 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31437 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2CIAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4I0DwEjIzUCGA4COwMhAYggqBqSBYEvjhGBFgSVRYVlijOCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086916"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 00/17] staging: tidspbridge: remove unused references counting
Date: Fri,  9 Mar 2012 01:03:35 +0100
Message-Id: <cover.1331250368.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almos all the modules in tidspbridge have a _init() and a _exit()
functions, whose only purpose is to keep a reference counting. But that
reference counting, in most of the cases, is utterly useless.

This patch series removes most of the _init() and _exit() function in
the tidspbridge modules, where no functional changes were implied.

Víctor Manuel Jáquez Leal (17):
  staging: tidspbridge: remove drv_init() and drv_exit()
  staging: tidspbridge: remove cod_init() and cod_exit()
  staging: tidspbridge: remove proc_init() and proc_exit()
  staging: tidspbridge: remove node_init() and node_exit()
  staging: tidspbridge: remove disp_init() and disp_exit()
  staging: tidspbridge: remove strm_init() and strm_exit()
  staging: tidspbridge: remove rmm_init() and rmm_exit()
  staging: tidspbridge: remove chnl_init() and chnl_exit()
  staging: tidspbridge: remove msg_mod_init() and msg_exit()
  staging: tidspbridge: remove io_init() and io_exit()
  staging: tidspbridge: remove cmm_init() and cmm_exit()
  staging: tidspbridge: remove dmm_init() and dmm_exit()
  staging: tidspbridge: remove dev_init() and dev_exit()
  staging: tidspbridge: simplify mgr_init()
  staging: tidspbridge: remove gh_init() and gh_exit()
  staging: tidspbridge: remove ref counting in nldr.c
  staging: tidspbridge: remove nldr_init() and nldr_exit()

 drivers/staging/tidspbridge/gen/gh.c               |   18 -----
 .../staging/tidspbridge/include/dspbridge/chnl.h   |   29 --------
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   30 --------
 .../staging/tidspbridge/include/dspbridge/cod.h    |   29 --------
 .../staging/tidspbridge/include/dspbridge/dev.h    |   27 -------
 .../staging/tidspbridge/include/dspbridge/disp.h   |   31 --------
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    4 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |   23 ------
 drivers/staging/tidspbridge/include/dspbridge/gh.h |    2 -
 drivers/staging/tidspbridge/include/dspbridge/io.h |   29 --------
 .../staging/tidspbridge/include/dspbridge/msg.h    |   27 -------
 .../staging/tidspbridge/include/dspbridge/nldr.h   |    2 -
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   34 ---------
 .../staging/tidspbridge/include/dspbridge/node.h   |   41 -----------
 .../tidspbridge/include/dspbridge/nodepriv.h       |    1 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |   28 -------
 .../staging/tidspbridge/include/dspbridge/rmm.h    |   25 -------
 .../staging/tidspbridge/include/dspbridge/strm.h   |   38 +----------
 drivers/staging/tidspbridge/pmgr/chnl.c            |   28 -------
 drivers/staging/tidspbridge/pmgr/cmm.c             |   29 --------
 drivers/staging/tidspbridge/pmgr/cod.c             |   29 --------
 drivers/staging/tidspbridge/pmgr/dbll.c            |   12 +---
 drivers/staging/tidspbridge/pmgr/dev.c             |   50 -------------
 drivers/staging/tidspbridge/pmgr/dmm.c             |   32 --------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   75 +------------------
 drivers/staging/tidspbridge/pmgr/io.c              |   28 -------
 drivers/staging/tidspbridge/pmgr/msg.c             |   21 ------
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   15 +----
 drivers/staging/tidspbridge/rmgr/disp.c            |   25 -------
 drivers/staging/tidspbridge/rmgr/drv.c             |   26 -------
 drivers/staging/tidspbridge/rmgr/mgr.c             |    9 +--
 drivers/staging/tidspbridge/rmgr/nldr.c            |   28 -------
 drivers/staging/tidspbridge/rmgr/node.c            |   31 --------
 drivers/staging/tidspbridge/rmgr/proc.c            |   28 -------
 drivers/staging/tidspbridge/rmgr/rmm.c             |   20 -----
 drivers/staging/tidspbridge/rmgr/strm.c            |   28 -------
 36 files changed, 10 insertions(+), 922 deletions(-)

-- 
1.7.9.1

