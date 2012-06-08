Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2FHFOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:14:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43287 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761466Ab2FHFH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:28 -0400
Message-Id: <20120608041847.673229768@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Frank Svendsboe <frank.svendsboe@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 51/82] mtd: of_parts: fix breakage in Kconfig
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Svendsboe <frank.svendsboe@gmail.com>

commit 2e929d001e85126d9267de373d4b76014789661d upstream.

MTD_OF_PARTS and the default setting is not working due to using 'Y'
instead of 'y', introduced in commit
d6137badeff1ef64b4e0092ec249ebdeaeb3ff37. This made our board, and
possibly other boards using DTS defined partitions and not having
CONFIG_MTD_OF_PARTS=y defined in the defconfig, fail to mount root.

Signed-off-by: Frank Svendsboe <frank.svendsboe@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mtd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 5760c1a..27143e0 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -128,7 +128,7 @@ config MTD_AFS_PARTS
 
 config MTD_OF_PARTS
 	tristate "OpenFirmware partitioning information support"
-	default Y
+	default y
 	depends on OF
 	help
 	  This provides a partition parsing function which derives


