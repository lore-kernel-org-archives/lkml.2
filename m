Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0IKXB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:01:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24450 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0IKXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:01:26 -0400
Date: Sat, 11 Sep 2010 16:00:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org
Subject: [PATCH] staging: ST_BT depends on RFKILL
Message-Id: <20100911160012.0055ae7b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig unmet dependency warning:

warning: (ST_BT && STAGING && !STAGING_EXCLUDE_BUILD && BT) selects TI_ST which has unmet direct dependencies (RFKILL)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/ti-st/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100908.orig/drivers/staging/ti-st/Kconfig
+++ linux-next-20100908/drivers/staging/ti-st/Kconfig
@@ -16,7 +16,7 @@ config TI_ST
 
 config ST_BT
 	tristate "BlueZ bluetooth driver for ST"
-	depends on BT
+	depends on BT && RFKILL
 	select TI_ST
 	help
 	  This enables the Bluetooth driver for TI BT/FM/GPS combo devices.
