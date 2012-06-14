Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2FNJYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:24:48 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:60766 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab2FNJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:24:47 -0400
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 1/2] UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer
Date: Thu, 14 Jun 2012 17:24:27 +0800
Message-Id: <1339665868-22602-1-git-send-email-gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When disintegrate system.h, I left an error in asm/cmpxchg.h, which
will result in following error:

arch/unicore32/include/asm/cmpxchg.h: In function '__xchg':
arch/unicore32/include/asm/cmpxchg.h:38: error: void value not ignored as it ought to be

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/cmpxchg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/unicore32/include/asm/cmpxchg.h b/arch/unicore32/include/asm/cmpxchg.h
index df4d5ac..8e797ad 100644
--- a/arch/unicore32/include/asm/cmpxchg.h
+++ b/arch/unicore32/include/asm/cmpxchg.h
@@ -35,7 +35,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			: "memory", "cc");
 		break;
 	default:
-		ret = __xchg_bad_pointer();
+		__xchg_bad_pointer();
 	}
 
 	return ret;
-- 
1.7.0.4

