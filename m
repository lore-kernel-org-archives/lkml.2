Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab0GSX6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 19:58:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63896 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760889Ab0GSX6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:12 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 26/49] memblock: Make memblock_alloc_try_nid() fallback to MEMBLOCK_ALLOC_ANYWHERE
Date: Mon, 19 Jul 2010 16:56:35 -0700
Message-Id: <1279583818-14249-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C44E67B.0137,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

memblock_alloc_nid() used to fallback to allocating anywhere by using
memblock_alloc() as a fallback.

However, some of my previous patches limit memblock_alloc() to the region
covered by MEMBLOCK_ALLOC_ACCESSIBLE which is not quite what we want
for memblock_alloc_try_nid().

So we fix it by explicitely using MEMBLOCK_ALLOC_ANYWHERE.

Not that so far only sparc uses memblock_alloc_nid() and it hasn't been updated
to clamp the accessible zone yet. Thus the temporary "breakage" should have
no effect.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c3c499e..424ca11 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -546,7 +546,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
 
 	if (res)
 		return res;
-	return memblock_alloc(size, align);
+	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ANYWHERE);
 }
 
 
-- 
1.6.4.2

