Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab0FJLPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:15:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0FJLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:42 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/23] pagemap: Avoid unused-but-set variable 
Message-Id: <20100610111039.ED2B2B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoid quite a lot of warnings in header files in a gcc 4.6 -Wall builds

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/pagemap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc2-gcc/include/linux/pagemap.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/include/linux/pagemap.h
+++ linux-2.6.35-rc2-gcc/include/linux/pagemap.h
@@ -423,8 +423,10 @@ static inline int fault_in_pages_readabl
 		const char __user *end = uaddr + size - 1;
 
 		if (((unsigned long)uaddr & PAGE_MASK) !=
-				((unsigned long)end & PAGE_MASK))
+				((unsigned long)end & PAGE_MASK)) {
 		 	ret = __get_user(c, end);
+			(void)c;
+		}
 	}
 	return ret;
 }
