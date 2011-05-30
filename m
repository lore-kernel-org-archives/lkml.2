Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1E3QEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:04:00 -0400
Received: from mx.treblig.org ([80.68.94.177]:36033 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab1E3QD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:03:59 -0400
Date: Mon, 30 May 2011 17:03:56 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        akpm@linux-foundation.org
Subject: [PATCH] Fix BUILD_BUG_ON_ZERO sparse breakage
Message-ID: <20110530160356.GA23646@gallifrey>
References: <20110529003857.GA9898@gallifrey> <4DE2F9BA.5030802@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE2F9BA.5030802@jp.fujitsu.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 16:49:24 up 101 days, 17:22,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUILD_BUG_ON_ZERO and BUILD_BUG_ON_NULL must return values, even in the CHECKER
case otherwise various users of it become syntactically invalid.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fb0e732..953352a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -671,8 +671,8 @@ struct sysinfo {
 
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
-#define BUILD_BUG_ON_ZERO(e)
-#define BUILD_BUG_ON_NULL(e)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
 #else /* __CHECKER__ */
 
