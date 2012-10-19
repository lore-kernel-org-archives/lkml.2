Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2JSK4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:56:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37791 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2JSK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:56:44 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] mm: Simplify for_each_populated_zone()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kosaki.motohiro@gmail.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Fri, 19 Oct 2012 16:25:47 +0530
Message-ID: <20121019105546.9704.93446.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101910-0260-0000-0000-00000201C255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the check for populated_zone() to the control statement of the
'for' loop and get rid of the odd looking if/else block.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 50aaca8..5bdf02e 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -913,11 +913,8 @@ extern struct zone *next_zone(struct zone *zone);
 
 #define for_each_populated_zone(zone)		        \
 	for (zone = (first_online_pgdat())->node_zones; \
-	     zone;					\
-	     zone = next_zone(zone))			\
-		if (!populated_zone(zone))		\
-			; /* do nothing */		\
-		else
+	     zone && populated_zone(zone);		\
+	     zone = next_zone(zone))
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {

