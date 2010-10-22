Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0JVS1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:27:10 -0400
Received: from kroah.org ([198.145.64.141]:37851 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759005Ab0JVSZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: dann frazier <dannf@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 27/31] hpilo: Despecificate driver from iLO generation
Date: Fri, 22 Oct 2010 11:25:12 -0700
Message-Id: <1287771916-15016-27-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dann frazier <dannf@hp.com>

This driver supports iLO, iLO2 and iLO3. However, comments and Kconfig
reference only iLO and iLO2. Let's just call it "iLO" to avoid having to
update strings for each iLO generation. This is similar to the change made
to hpwdt in commit 36e3ff44cebd7e46756dec88f30c982bebefdab7.

Signed-off-by: dann frazier <dannf@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/Kconfig |   10 +++++-----
 drivers/misc/hpilo.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6f46e27..db2fbe2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -248,15 +248,15 @@ config CS5535_CLOCK_EVENT_SRC
 	  generic PIT, and are suitable for use as high-res timers.
 
 config HP_ILO
-	tristate "Channel interface driver for HP iLO/iLO2 processor"
+	tristate "Channel interface driver for the HP iLO processor"
 	depends on PCI
 	default n
 	help
 	  The channel interface driver allows applications to communicate
-	  with iLO/iLO2 management processors present on HP ProLiant
-	  servers.  Upon loading, the driver creates /dev/hpilo/dXccbN files,
-	  which can be used to gather data from the management processor,
-	  via read and write system calls.
+	  with iLO management processors present on HP ProLiant servers.
+	  Upon loading, the driver creates /dev/hpilo/dXccbN files, which
+	  can be used to gather data from the management processor, via
+	  read and write system calls.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called hpilo.
diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 557a8c2..d4158ec 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -1,5 +1,5 @@
 /*
- * Driver for HP iLO/iLO2 management processor.
+ * Driver for the HP iLO management processor.
  *
  * Copyright (C) 2008 Hewlett-Packard Development Company, L.P.
  *	David Altobelli <david.altobelli@hp.com>
-- 
1.7.2

