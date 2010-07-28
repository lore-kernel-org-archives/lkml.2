Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0G1VAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:00:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49154 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0G1VAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:00:19 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH 0/5] use idr kernel library instead of handles
Date: Wed, 28 Jul 2010 16:04:52 -0500
Message-Id: <1280351097-3346-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rene Sapiens <rene.sapiens@ti.com>

Use idr kernel library to send/receive node and stream ids to the
user instead of kernel address.
This id will be use to access the node and stream handles at the
kernel side, if id does not match to any handle
error -EFAULT is returned.

For processor handle, dspbridge driver will make sure
the handle is valid by using the handle stored in process context.

Ernesto Ramos (5):
  staging:ti dspbridge: use node id instead of kernel address
  staging:ti dspbridge: avoid errors if node handle is zero
  staging:ti dspbridge: use processor handle from context instead of
    user's
  staging:ti dspbridge: use stream id instead of kernel address
  staging:ti dspbridge: avoid errors if stream id is zero

 .../staging/tidspbridge/include/dspbridge/drv.h    |   11 +-
 .../staging/tidspbridge/include/dspbridge/node.h   |   14 +-
 .../include/dspbridge/resourcecleanup.h            |   12 -
 .../staging/tidspbridge/include/dspbridge/strm.h   |   22 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |  329 ++++++++++++++++----
 drivers/staging/tidspbridge/rmgr/drv.c             |  303 ++++++-------------
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   18 +-
 drivers/staging/tidspbridge/rmgr/node.c            |  109 ++++---
 drivers/staging/tidspbridge/rmgr/strm.c            |   54 ++--
 9 files changed, 485 insertions(+), 387 deletions(-)

