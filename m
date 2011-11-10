Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101Ab1KJQUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:20:14 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:59195 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061Ab1KJQUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:20:11 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] PM/Usermodehelper: Cleanup remnants of
 usermodehelper_pm_callback()
To: rjw@sisk.pl
Cc: dhowells@redhat.com, eparis@redhat.com, kay.sievers@vrfy.org,
        jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Thu, 10 Nov 2011 21:49:29 +0530
Message-ID: <20111110161921.3714.25382.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11111007-3568-0000-0000-000000AC18CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usermodehelper_pm_callback() no longer exists in the kernel. There are 2
comments in kernel/kmod.c that still refer to it.

Also, the patch that introduced usermodehelper_pm_callback(), #included
2 header files: <linux/notifier.h> and <linux/suspend.h>. But these are
no longer necessary.

This patch updates the comments as appropriate and removes the unnecessary
header file inclusions.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/kmod.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index a4bea97..2142687 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -34,8 +34,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
-#include <linux/notifier.h>
-#include <linux/suspend.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -282,14 +280,14 @@ static int usermodehelper_disabled = 1;
 static atomic_t running_helpers = ATOMIC_INIT(0);
 
 /*
- * Wait queue head used by usermodehelper_pm_callback() to wait for all running
+ * Wait queue head used by usermodehelper_disable() to wait for all running
  * helpers to finish.
  */
 static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
 
 /*
  * Time to wait for running_helpers to become zero before the setting of
- * usermodehelper_disabled in usermodehelper_pm_callback() fails
+ * usermodehelper_disabled in usermodehelper_disable() fails
  */
 #define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
 

