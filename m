Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2CAIO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:14:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47271 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab2CAIMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.82.132 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Michal Simek <monstr@monstr.eu>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 2/7] remoteproc: remoteproc_rpmsg -> remoteproc_virtio
Date: Thu,  1 Mar 2012 10:11:32 +0200
Message-Id: <1330589497-4139-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point remoteproc can only register a single VIRTIO_ID_RPMSG virtio
device.

This limitation is going away soon: remoteproc is getting support for
registering any number of virtio devices and of any type (as
published by the firmware of the remote processor).

Rename remoteproc_rpmsg.c to remoteproc_virtio.c in preparation of
this generalization work.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Iliyan Malchev <malchev@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Guzman Lugo Fernando <fernando.lugo@ti.com>
Cc: Anna Suman <s-anna@ti.com>
Cc: Clark Rob <rob@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kieran Bingham <kieranbingham@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 drivers/remoteproc/Makefile                        |    2 +-
 .../{remoteproc_rpmsg.c => remoteproc_virtio.c}    |    0
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename drivers/remoteproc/{remoteproc_rpmsg.c => remoteproc_virtio.c} (100%)

diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
index df0897f..5445d9b 100644
--- a/drivers/remoteproc/Makefile
+++ b/drivers/remoteproc/Makefile
@@ -5,5 +5,5 @@
 obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
 remoteproc-y				:= remoteproc_core.o
 remoteproc-y				+= remoteproc_debugfs.o
-remoteproc-y				+= remoteproc_rpmsg.o
+remoteproc-y				+= remoteproc_virtio.o
 obj-$(CONFIG_OMAP_REMOTEPROC)		+= omap_remoteproc.o
diff --git a/drivers/remoteproc/remoteproc_rpmsg.c b/drivers/remoteproc/remoteproc_virtio.c
similarity index 100%
rename from drivers/remoteproc/remoteproc_rpmsg.c
rename to drivers/remoteproc/remoteproc_virtio.c
-- 
1.7.5.4

