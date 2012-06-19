Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab2FSIfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:35:14 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:46733 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FSIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:35:10 -0400
Message-ID: <4FE039A6.4050206@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:34:46 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 04/10] zcache: remove unnecessary check of config option dependence
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061822-5140-0000-0000-00000198E436
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache is enabled only if one of CONFIG_CLEANCACHE and CONFIG_FRONTSWAP is
enabled, see the Kconfig:
	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
So, we can remove the check in the source code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 74a3ac8..82d752d 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -35,9 +35,6 @@

 #include "../zsmalloc/zsmalloc.h"

-#if (!defined(CONFIG_CLEANCACHE) && !defined(CONFIG_FRONTSWAP))
-#error "zcache is useless without CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"
-#endif
 #ifdef CONFIG_CLEANCACHE
 #include <linux/cleancache.h>
 #endif
@@ -2017,7 +2014,7 @@ static int __init zcache_init(void)
 		goto out;
 	}
 #endif /* CONFIG_SYSFS */
-#if defined(CONFIG_CLEANCACHE) || defined(CONFIG_FRONTSWAP)
+
 	if (zcache_enabled) {
 		unsigned int cpu;

@@ -2048,7 +2045,7 @@ static int __init zcache_init(void)
 		pr_err("zcache: can't create client\n");
 		goto out;
 	}
-#endif
+
 #ifdef CONFIG_CLEANCACHE
 	if (zcache_enabled && use_cleancache) {
 		struct cleancache_ops old_ops;
-- 
1.7.7.6

