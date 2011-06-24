Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1FXVpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:45:19 -0400
Received: from mail.solarflare.com ([216.237.3.220]:20805 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1FXVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:45:16 -0400
Subject: [PATCH] sparse: Fix BUILD_BUG_ON_{ZERO,NULL} definitions
From: Ben Hutchings <bhutchings@solarflare.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 24 Jun 2011 22:45:12 +0100
Message-ID: <1308951912.3034.23.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 21:45:14.0944 (UTC) FILETIME=[006D5C00:01CC32B8]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18218.005
X-TM-AS-Result: No--15.436700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad ('sparse: define dummy
BUILD_BUG_ON definition for sparse') left these two broken.  The ZERO
or NULL suffix specifies what the macro should expand to, not the
value that would indicate a bug.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
sparse currently reports a syntax error and no useful warnings for any
source file which uses one of these macros.  Since module_param() uses
BUILD_BUG_ON_ZERO(), that's a lot of source files.

Ben.

 include/linux/kernel.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fb0e732..fccd366 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -671,8 +671,8 @@ struct sysinfo {
 
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
-#define BUILD_BUG_ON_ZERO(e)
-#define BUILD_BUG_ON_NULL(e)
+#define BUILD_BUG_ON_ZERO(e) ((size_t)0)
+#define BUILD_BUG_ON_NULL(e) ((void *)0)
 #define BUILD_BUG_ON(condition)
 #else /* __CHECKER__ */
 
-- 
1.7.4.4


-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

