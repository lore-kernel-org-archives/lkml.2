Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1FZVFc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 17:05:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59337 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab1FZVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 17:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aJTJYK78RTnYn//65HnOzOm9rbUEg5ZFjpbKi4H+w+FexcxQA2TJhYX0x4/2LcqsIV
         Epht6DrG5W6Pqycf4i4Srx2C7Sz0SOhnT6mPOKukrghk9KQ5cuPOgk8JwZTC2p+ING+9
         6UffHoMsuVzUdlSdP6FSiKQWH8/RSIde1q0hI=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mtd: make ofpart buildable as a separate module
Date: Mon, 27 Jun 2011 01:02:59 +0400
Message-Id: <1309122180-12838-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As ofpart now uses a standard mtd partitions parser interface, make it
buildable as a separate module. Also provide MODULE_DESCRIPTION and
MODULE_AUTHOR for this module.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/mtd/Kconfig  |    3 ++-
 drivers/mtd/Makefile |    2 +-
 drivers/mtd/ofpart.c |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 4be8373..cc02e21 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -137,7 +137,8 @@ config MTD_AFS_PARTS
 	  'physmap' map driver (CONFIG_MTD_PHYSMAP) does this, for example.
 
 config MTD_OF_PARTS
-	def_bool y
+	tristate "OpenFirmware partitioning information support"
+	default Y
 	depends on OF
 	help
 	  This provides a partition parsing function which derives
diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 39664c4..9aaac3a 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -5,8 +5,8 @@
 # Core functionality.
 obj-$(CONFIG_MTD)		+= mtd.o
 mtd-y				:= mtdcore.o mtdsuper.o mtdconcat.o mtdpart.o
-mtd-$(CONFIG_MTD_OF_PARTS)	+= ofpart.o
 
+obj-$(CONFIG_MTD_OF_PARTS)	+= ofpart.o
 obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
 obj-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
 obj-$(CONFIG_MTD_AFS_PARTS)	+= afs.o
diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index 41c4518..aa33b8a 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -174,3 +174,5 @@ out:
 module_init(ofpart_parser_init);
 
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
+MODULE_AUTHOR("Vitaly Wool, David Gibson");
-- 
1.7.5.4

