Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab2DXBe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:34:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36550 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2DXBeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:34:25 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Autif Khan <autif.mlist@gmail.com>
Subject: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
Date: Mon, 23 Apr 2012 20:33:50 -0500
Message-Id: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042401-3352-0000-0000-000004392E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZCACHE is a boolean in the Kconfig.  When selected, it
should require that CRYPTO be builtin (=y).

Currently, ZCACHE=y and CRYPTO=m is a valid configuration
when it should not be.

This patch changes the zcache Kconfig to enforce this
dependency.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 3ed2c8f..7048e01 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -2,7 +2,7 @@ config ZCACHE
 	bool "Dynamic compression of swap pages and clean pagecache pages"
 	# X86 dependency is because zsmalloc uses non-portable pte/tlb
 	# functions
-	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
+	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
 	select ZSMALLOC
 	select CRYPTO_LZO
 	default n
-- 
1.7.5.4

