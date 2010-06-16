Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0FPFoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:44:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26378 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0FPFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:44:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/37] lmb: Print new doubled array location info
Date: Tue, 15 Jun 2010 22:42:12 -0700
Message-Id: <1276666966-14259-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4C186499.01A8,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so will have more idea where it is,  use lmb_debug to controll it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 lib/lmb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index bbdb1ec..7a6e11a 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -192,8 +192,6 @@ static int lmb_double_array(struct lmb_type *type)
 	if (!lmb_can_resize)
 		return -1;
 
-	pr_debug("lmb: %s array full, doubling...", lmb_type_name(type));
-
 	/* Calculate new doubled size */
 	old_size = type->max * sizeof(struct lmb_region);
 	new_size = old_size << 1;
@@ -221,6 +219,10 @@ static int lmb_double_array(struct lmb_type *type)
 	}
 	new_array = __va(addr);
 
+	if (lmb_debug)
+		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
+			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
+
 	/* Found space, we now need to move the array over before
 	 * we add the reserved region since it may be our reserved
 	 * array itself that is full.
-- 
1.6.4.2

