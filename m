Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab3AHVIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:29241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3AHVH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:07:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604820"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 00/21] MEI restructuring
Date: Tue,  8 Jan 2013 23:07:11 +0200
Message-Id: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains some initial restructuring
of the MEI driver. It tries to make cleaner
lines between ME hardware, Host Bust Messaging,
and Client Management layers. For sake of that
we have moved functions around and renamed some
files. 


Tomas Winkler (21):
  mei: add new hbm.h header to export hbm protocol
  mei: move client functions to client.c
  mei: fix client functions names
  mei: implement mei_cl_connect function
  mei: move watchdog prototypes to mei_dev.h from interface.h
  mei: rename interface to hw-me
  mei: drop read_pending member form struct mei_cl
  mei: move me client storage allocation to hbm.c
  mei: mei_dev.h - remove prototypes of dropped functions
  mei: rename remaining amthi strings to amthif
  mei: normalize me host client linking routines
  mei: move MEI_IAMTHIF_IDLE to amthif host init function
  mei: hw-me.c fix kernel doc
  mei: remove write only need_reset member of struct mei_device
  mei: remove mei_csr_clear_his prototype
  mei: don't use cached value for hcsr in mei_hw_reset
  mei: use non cached hcsr for interrupt enablement
  mei: abstract host and device readieness
  mei: reenable mei_hcsr_set abstraction
  mei: make host csr and me csr internal to hw-me
  mei: move work initialization to mei_device_init

 drivers/misc/mei/Makefile                 |    4 +-
 drivers/misc/mei/amthif.c                 |  112 +++--
 drivers/misc/mei/client.c                 |  678 +++++++++++++++++++++++++++++
 drivers/misc/mei/client.h                 |   97 ++++
 drivers/misc/mei/hbm.c                    |   42 ++-
 drivers/misc/mei/hbm.h                    |   39 ++
 drivers/misc/mei/hw-me-regs.h             |  167 +++++++
 drivers/misc/mei/{interface.c => hw-me.c} |  241 +++++------
 drivers/misc/mei/hw-me.h                  |  181 ++-------
 drivers/misc/mei/init.c                   |  405 ++----------------
 drivers/misc/mei/interface.h              |   83 ----
 drivers/misc/mei/interrupt.c              |   37 +-
 drivers/misc/mei/iorw.c                   |  366 ----------------
 drivers/misc/mei/main.c                   |  184 ++++++---
 drivers/misc/mei/mei_dev.h                |  115 ++----
 drivers/misc/mei/wd.c                     |   49 ++-
 16 files changed, 1468 insertions(+), 1332 deletions(-)
 create mode 100644 drivers/misc/mei/client.c
 create mode 100644 drivers/misc/mei/client.h
 create mode 100644 drivers/misc/mei/hbm.h
 create mode 100644 drivers/misc/mei/hw-me-regs.h
 rename drivers/misc/mei/{interface.c => hw-me.c} (68%)
 delete mode 100644 drivers/misc/mei/interface.h
 delete mode 100644 drivers/misc/mei/iorw.c

-- 
1.7.4.4

