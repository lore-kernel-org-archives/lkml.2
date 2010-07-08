Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0GHHRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:17:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:51549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0GHHRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:17:35 -0400
Date: Thu, 8 Jul 2010 07:17:15 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tony.luck@intel.com, dtor@mail.ru, tglx@linutronix.de,
       feng.tang@intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, dtor@mail.ru, tglx@linutronix.de,
       feng.tang@intel.com, hpa@linux.intel.com
In-Reply-To: <4c34dd482753bb8f1@agluck-desktop.sc.intel.com>
References: <4c34dd482753bb8f1@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] input: i8042 - add runtime check in x86's i8042_platform_init
Message-ID: <tip-5cdfa1c3bbabb809ef3134f741a63e13373a8cad@git.kernel.org>
Git-Commit-ID: 5cdfa1c3bbabb809ef3134f741a63e13373a8cad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Jul 2010 07:17:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cdfa1c3bbabb809ef3134f741a63e13373a8cad
Gitweb:     http://git.kernel.org/tip/5cdfa1c3bbabb809ef3134f741a63e13373a8cad
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed, 7 Jul 2010 13:02:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 7 Jul 2010 17:05:07 -0700

input: i8042 - add runtime check in x86's i8042_platform_init

Then it will first check x86_platforms's i8042 detection result,
then go on with normal probe.

Signed-off-by: Feng Tang <feng.tang@intel.com>
LKML-Reference: <4c34dd482753bb8f1@agluck-desktop.sc.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/input/serio/i8042-x86ia64io.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..81003c4 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -7,6 +7,10 @@
  * the Free Software Foundation.
  */
 
+#ifdef CONFIG_X86
+#include <asm/x86_init.h>
+#endif
+
 /*
  * Names.
  */
@@ -840,6 +844,12 @@ static int __init i8042_platform_init(void)
 {
 	int retval;
 
+#ifdef CONFIG_X86
+	/* Just return if pre-detection shows no i8042 controller exist */
+	if (!x86_platform.i8042_detect())
+		return -ENODEV;
+#endif
+
 /*
  * On ix86 platforms touching the i8042 data register region can do really
  * bad things. Because of this the region is always reserved on ix86 boxes.
