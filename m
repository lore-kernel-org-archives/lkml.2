Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2FSIgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:36:44 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36113 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2FSIgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:36:42 -0400
Message-ID: <4FE039D4.6040703@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 16:35:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 06/10] zcache: cleanup zbud_init
References: <4FE0392E.3090300@linux.vnet.ibm.com>
In-Reply-To: <4FE0392E.3090300@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061908-2674-0000-0000-000004F27C7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need not set global parameters to 0

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index d194303..c18130f 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -599,11 +599,9 @@ static void __init zbud_init(void)
 	int i;

 	INIT_LIST_HEAD(&zbud_buddied_list);
-	zcache_zbud_buddied_count = 0;
-	for (i = 0; i < NCHUNKS; i++) {
+
+	for (i = 0; i < NCHUNKS; i++)
 		INIT_LIST_HEAD(&zbud_unbuddied[i].list);
-		zbud_unbuddied[i].count = 0;
-	}
 }

 #ifdef CONFIG_SYSFS
-- 
1.7.7.6

