Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0FVR2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:28:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31647 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab0FVR2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:13 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/25] lmb: lmb_find_base() should return LMB_ERROR on failing path
Date: Tue, 22 Jun 2010 10:26:30 -0700
Message-Id: <1277227614-11581-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4C20F28F.0095,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all callees assume it return LMB_ERROR when it fail to find a range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 lib/lmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index 2421b2a..13d1a04 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -154,7 +154,7 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
 		if (found != LMB_ERROR)
 			return found;
 	}
-	return 0;
+	return LMB_ERROR;
 }
 
 static void lmb_remove_region(struct lmb_type *type, unsigned long r)
-- 
1.6.4.2

