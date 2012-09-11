Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab2IJUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:09:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54760 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2IJUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:09:33 -0400
Date: Mon, 10 Sep 2012 19:18:12 -0700
From: DanielC <puff65537@bansheeslibrary.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 3.6rc5.linux-next 1/1] Staging: silicom: Force depend on
 module
Message-ID: <20120911021812.GA20636@elbert.example.com>
References: <20120910170409.59b71819008bc527130d3987@canb.auug.org.au>
 <20120910173153.GA25033@kroah.com>
 <20120911014330.GA15327@elbert.example.com>
 <20120910180413.GA31046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910180413.GA31046@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Staging: silicom: Force depend on module until monolithic build fixed

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Daniel Cotey <puff65537@bansheeslibrary.com>

---
 drivers/staging/silicom/Kconfig | 5 ++++-
 drivers/staging/silicom/TODO    | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/Kconfig b/drivers/staging/silicom/Kconfig
index 1914844..045ab08 100644
--- a/drivers/staging/silicom/Kconfig
+++ b/drivers/staging/silicom/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_SILICOM
 	bool "Silicom devices"
 	default y
-	depends on (SSB_POSSIBLE && HAS_DMA) || PCI 
+	depends on PCI 
 	depends on BROKEN
 	---help---
 	  If you have a network card (Ethernet) belonging to this class,
@@ -20,6 +20,8 @@ if NET_VENDOR_SILICOM
 
 config SBYPASS
 	tristate "Silicom BypassCTL library support"
+	depends on PCI
+	depends on m
 	---help---
 	  If you have a network (Ethernet) controller of this type, say Y
 
@@ -29,6 +31,7 @@ config SBYPASS
 config BPCTL
 	tristate "Silicom BypassCTL net support"
 	depends on PCI
+	depends on m
 	select SBYPASS
 	select NET_CORE
 	select MII
diff --git a/drivers/staging/silicom/TODO b/drivers/staging/silicom/TODO
index bf60714..a39821f 100644
--- a/drivers/staging/silicom/TODO
+++ b/drivers/staging/silicom/TODO
@@ -3,5 +3,6 @@ TODO:
 	- locking audit
 	- single module with all functionality
 	- userland 
+        - fix monolithic build.
 
 
-- 
1.7.11.4

