Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab0EMBVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:21:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41117 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab0EMBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=lfau5qdhYcMnDzxkBf0ZR5Y6CFzvrU9KbLHs/zJN6uL+C8vuCIBwbCltXqd3qMNOCm
         iVPZE4xHPdl42P24dDi2O9EVuZNOz1LVCeu9pXG2Cs+/QDeEEgTR9EiIe+zUuSn5k1Ya
         xscOICOXCKpK+OY8dcEM1TrM2lLPjUAe4p8JU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 8/9] lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
Date: Thu, 13 May 2010 03:21:13 +0200
Message-Id: <1273713674-8434-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panic on softlockups was still depending on the softlockup detector.
But the latter has been merged into the lockup detector now.

Let's update this config dependency.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 49e285d..755713a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -195,7 +195,7 @@ config LOCKUP_DETECTOR
 
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
-	depends on DETECT_SOFTLOCKUP
+	depends on LOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to panic on "soft lockups",
 	  which are bugs that cause the kernel to loop in kernel
-- 
1.6.2.3

