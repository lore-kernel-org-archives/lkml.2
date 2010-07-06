Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0GFWqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:46:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32492 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab0GFWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:44:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 27/49] memblock: memblock_find_base() should return MEMBLOCK_ERROR on failing path
Date: Tue,  6 Jul 2010 15:39:20 -0700
Message-Id: <1278455982-24621-28-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C33B1AA.0096,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all callees assume it return MEMBLOCK_ERROR when it fail to find a range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c71b847..8ed7901 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -154,7 +154,7 @@ static phys_addr_t __init memblock_find_base(phys_addr_t size, phys_addr_t align
 		if (found != MEMBLOCK_ERROR)
 			return found;
 	}
-	return 0;
+	return MEMBLOCK_ERROR;
 }
 
 static void memblock_remove_region(struct memblock_type *type, unsigned long r)
-- 
1.6.4.2

