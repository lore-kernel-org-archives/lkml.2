Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2KSLVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:21:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46733 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2KSLVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:21:11 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: khlebnikov@openvz.org, akpm@linux-foundation.org, patches@linaro.org
Subject: [PATCH] bug: Fix sparse warning related to BUILD_BUG_ON_INVALID
Date: Mon, 19 Nov 2012 16:45:02 +0530
Message-Id: <1353323702-13130-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit baf05aa9271b ("bug: introduce BUILD_BUG_ON_INVALID() macro")
introduces this macro when only _CHECKER_ is defined. Define
a silent macro in the else condition to fix following sparse
warning.

mm/filemap.c:395:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
mm/filemap.c:396:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
mm/filemap.c:397:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
include/linux/mm.h:419:9: error: undefined identifier 'BUILD_BUG_ON_INVALID'
include/linux/mm.h:419:9: error: not a function <noident>

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 include/linux/bug.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/bug.h b/include/linux/bug.h
index aaac4bb..b1cf40d 100644
--- a/include/linux/bug.h
+++ b/include/linux/bug.h
@@ -15,6 +15,7 @@ struct pt_regs;
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
+#define BUILD_BUG_ON_INVALID(e) (0)
 #define BUILD_BUG_ON(condition)
 #define BUILD_BUG() (0)
 #else /* __CHECKER__ */
-- 
1.7.4.1

