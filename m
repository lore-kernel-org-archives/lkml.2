Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1C3IhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:37:17 -0400
Received: from smtp.nokia.com ([147.243.128.24]:58035 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab1C3IhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:37:12 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] UBI: do not select KALLSYMS_ALL
Date: Wed, 30 Mar 2011 11:40:16 +0300
Message-Id: <1301474416-8202-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

All UBI needs is to make sure we stacktraces when UBI debugging
is enabled. It is enough to select KALLSYMS for this, KALLSYMS_ALL
is not necessary.

And the current Kconfig line we have:

select KALLSYMS_ALL if KALLSYMS && DEBUG_KERNEL

is just too complex to be sane and right. But this "if" part there
is needed to prevent "unmet direct dependency" warnings, because
KALLSYMS_ALL depends on KALLSYMS and DEBUG_KERNEL, so we cannot
just select KALLSYMS_ALL.

Anyway, this feels messy, and we do not seem to really need KALLSYMS_ALL,
so select KALLSYMS instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 drivers/mtd/ubi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 6abeb4f..4dcc752 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -56,7 +56,7 @@ config MTD_UBI_DEBUG
 	bool "UBI debugging"
 	depends on SYSFS
 	select DEBUG_FS
-	select KALLSYMS_ALL if KALLSYMS && DEBUG_KERNEL
+	select KALLSYMS
 	help
 	  This option enables UBI debugging.
 
-- 
1.7.2.3

