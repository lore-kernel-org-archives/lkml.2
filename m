Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0KXI6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:58:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57865 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0KXI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:58:03 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH 5/6] mm: add some KERN_CONT markers to continuation lines
Date: Wed, 24 Nov 2010 09:57:49 +0100
Message-Id: <1290589070-854-5-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101124085645.GW4693@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: linux-mm@kvack.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 mm/percpu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..3356646 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1117,20 +1117,20 @@ static void pcpu_dump_alloc_info(const char *lvl,
 		for (alloc_end += gi->nr_units / upa;
 		     alloc < alloc_end; alloc++) {
 			if (!(alloc % apl)) {
-				printk("\n");
-				printk("%spcpu-alloc: ", lvl);
+				printk(KERN_CONT "\n");
+				printk("%spcpu-alloc:", lvl);
 			}
-			printk("[%0*d] ", group_width, group);
+			printk(KERN_CONT " [%0*d]", group_width, group);
 
 			for (unit_end += upa; unit < unit_end; unit++)
 				if (gi->cpu_map[unit] != NR_CPUS)
-					printk("%0*d ", cpu_width,
+					printk(KERN_CONT " %0*d", cpu_width,
 					       gi->cpu_map[unit]);
 				else
-					printk("%s ", empty_str);
+					printk(KERN_CONT " %s", empty_str);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 /**
-- 
1.7.2.3

