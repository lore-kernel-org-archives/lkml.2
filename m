Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0EHPVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:21:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63625 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0EHPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/22] lmb: Prepare to include linux/lmb.h in core file
Date: Sat,  8 May 2010 08:17:28 -0700
Message-Id: <1273331860-14325-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BE58101.014B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to add protection in linux/lmb.h, to prepare to include it in
 mm/page_alloc.c and mm/bootmem.c etc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 85918a4..58db7e9 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -2,6 +2,7 @@
 #define _LINUX_LMB_H
 #ifdef __KERNEL__
 
+#ifdef CONFIG_HAVE_LMB
 /*
  * Logical memory blocks.
  *
@@ -102,6 +103,8 @@ u64 lmb_hole_size(u64 start, u64 end);
 
 #include <asm/lmb.h>
 
+#endif /* CONFIG_HAVE_LMB */
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_LMB_H */
-- 
1.6.4.2

