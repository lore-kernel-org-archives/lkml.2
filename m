Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1BBBFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:05:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:4194 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab1BBAno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504963"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [39/139] sparc64: Unexport prom_service_exists().
Message-Id: <20110202004354.99A423E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit f7b5f55ac1623dfde24ef5319ad77c1746645f3f ]

Only used by functions in misc_64.c so make it private
to that file.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/sparc/include/asm/oplib_64.h |    1 -
 arch/sparc/prom/misc_64.c         |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/include/asm/oplib_64.h
+++ linux-2.6.35.y/arch/sparc/include/asm/oplib_64.h
@@ -258,7 +258,6 @@ extern int prom_setprop(int node, const 
 			int value_size);
 
 extern int prom_inst2pkg(int);
-extern int prom_service_exists(const char *service_name);
 extern void prom_sun4v_guest_soft_state(void);
 
 extern int prom_ihandle2path(int handle, char *buffer, int bufsize);
Index: linux-2.6.35.y/arch/sparc/prom/misc_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/sparc/prom/misc_64.c
+++ linux-2.6.35.y/arch/sparc/prom/misc_64.c
@@ -18,7 +18,7 @@
 #include <asm/system.h>
 #include <asm/ldc.h>
 
-int prom_service_exists(const char *service_name)
+static int prom_service_exists(const char *service_name)
 {
 	unsigned long args[5];
 
