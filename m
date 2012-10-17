Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2JQOy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:54:29 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47836 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2JQOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:54:28 -0400
MIME-Version: 1.0
Date: Wed, 17 Oct 2012 22:54:27 +0800
Message-ID: <CAPgLHd9enojK7tbCxWKyHnzgnSYZUGqAiAgevn6uamrw_3t4Mg@mail.gmail.com>
Subject: [PATCH] CRIS: locking: fix the return value of arch_read_trylock()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: yongjun_wei@trendmicro.com.cn, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

arch_write_trylock() should return 'ret' instead of always
return 1.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/cris/include/arch-v32/arch/spinlock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/include/arch-v32/arch/spinlock.h b/arch/cris/include/arch-v32/arch/spinlock.h
index f171a66..f132755 100644
--- a/arch/cris/include/arch-v32/arch/spinlock.h
+++ b/arch/cris/include/arch-v32/arch/spinlock.h
@@ -118,7 +118,7 @@ static  inline int arch_write_trylock(arch_rwlock_t *rw)
 		ret = 1;
 	}
 	arch_spin_unlock(&rw->slock);
-	return 1;
+	return ret;
 }
 
 #define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)


