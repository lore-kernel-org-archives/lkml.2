Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751029Ab0CXEKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:10:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60143 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0CXEK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UWIcpe4QYzO9EAMJLbIA+s59h3K/thbxuGg5yfaNVPDvjFFnV7Z5Dg0NOTFRjg1Kp7
         QKtD/Z8tG+9/O1fLIKkaWWwMGfzJLzUS9B8n8SDS/4e71w4czfBUkMVJO9liFXIIdLs3
         SmmtNGCmvpL5GfvTGdf9eq315wPkiRPvYhnMs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-xtensa-patches@linux-xtensa.org,
       linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] Replace old style lock initializer
Date: Tue, 23 Mar 2010 21:10:10 -0700
Message-Id: <1269403810-31037-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to be on some deprecated thing. So after searching 
the kernel I found: 
SPIN_LOCK_UNLOCKED is deprecated, and that __SPIN_LOCK_UNLOCKED
should be used. My finding's have found this, so hopefully it's 
legit.(the kernel compiles, but if anything else breaks
am unsure due to not having this arch). 


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 arch/alpha/include/asm/rwsem.h  |    2 +-
 arch/xtensa/include/asm/rwsem.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/rwsem.h b/arch/alpha/include/asm/rwsem.h
index 1570c0b..f9dd7fe 100644
--- a/arch/alpha/include/asm/rwsem.h
+++ b/arch/alpha/include/asm/rwsem.h
@@ -39,7 +39,7 @@ struct rw_semaphore {
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED, \
 	LIST_HEAD_INIT((name).wait_list) }
 
 #define DECLARE_RWSEM(name) \
diff --git a/arch/xtensa/include/asm/rwsem.h b/arch/xtensa/include/asm/rwsem.h
index e39edf5..1b3865c 100644
--- a/arch/xtensa/include/asm/rwsem.h
+++ b/arch/xtensa/include/asm/rwsem.h
@@ -38,7 +38,7 @@ struct rw_semaphore {
 };
 
 #define __RWSEM_INITIALIZER(name) \
-	{ RWSEM_UNLOCKED_VALUE, SPIN_LOCK_UNLOCKED, \
+	{ RWSEM_UNLOCKED_VALUE, __SPIN_LOCK_UNLOCKED, \
 	  LIST_HEAD_INIT((name).wait_list) }
 
 #define DECLARE_RWSEM(name)		\
-- 
1.6.5.GIT

