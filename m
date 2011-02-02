Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1BBAnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:36336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BBAnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622340"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [36/139] sparc64: Delete prom_puts() unused.
Message-Id: <20110202004351.79B313E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit ce05a94efaf71d562eeefd30d6bbc2ab42b06bac ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/prom/console_64.c |   16 ----------------
 1 file changed, 16 deletions(-)

Index: linux-2.6.35.y/arch/sparc/prom/console_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/console_64.c
+++ linux-2.6.35.y/arch/sparc/prom/console_64.c
@@ -81,19 +81,3 @@ prom_putchar(char c)
 {
 	prom_nbputchar(c);
 }
-
-void
-prom_puts(const char *s, int len)
-{
-	unsigned long args[7];
-
-	args[0] = (unsigned long) "write";
-	args[1] = 3;
-	args[2] = 1;
-	args[3] = (unsigned int) prom_stdout;
-	args[4] = (unsigned long) s;
-	args[5] = len;
-	args[6] = (unsigned long) -1;
-
-	p1275_cmd_direct(args);
-}
