Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2CEQsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:48:18 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40206 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab2CEQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:48:16 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: zcache: make zcache builtin only
Date: Mon,  5 Mar 2012 10:46:38 -0600
Message-Id: <1330965998-12116-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030516-5518-0000-0000-000002BC7132
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache cannot currently be loaded as a module.  However
the Kconfig allows it to be built as a module; something that
the user probably does not intend since the module is not
loadable.

This patch switches zcache from a tristate to a bool in the Kconfig

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 5a36fcf..3ed2c8f 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -1,5 +1,5 @@
 config ZCACHE
-	tristate "Dynamic compression of swap pages and clean pagecache pages"
+	bool "Dynamic compression of swap pages and clean pagecache pages"
 	# X86 dependency is because zsmalloc uses non-portable pte/tlb
 	# functions
 	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
-- 
1.7.5.4

