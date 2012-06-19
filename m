Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2FSIc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:32:58 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47587 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2FSIcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:32:55 -0400
Message-ID: <4FE0392E.3090300@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:32:46 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 01/10] zcache: fix preemptable memory allocation in atomic
 context
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061822-5490-0000-0000-0000019EECC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zcache_do_preload uses ZCACHE_GFP_MASK to allocate memory that will be sleep,
but zcache_do_preload is called in zcache_put_page where IRQ is disabled

Fix it by use GFP_ATOMIC flag

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 03f690b..d215fb4 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -45,13 +45,8 @@
 #include <linux/frontswap.h>
 #endif

-#if 0
 /* this is more aggressive but may cause other problems? */
 #define ZCACHE_GFP_MASK	(GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN)
-#else
-#define ZCACHE_GFP_MASK \
-	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
-#endif

 #define MAX_POOLS_PER_CLIENT 16

-- 
1.7.7.6

