Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0GGUCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:02:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:47123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab0GGUCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:02:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,554,1272870000"; 
   d="scan'208";a="533342709"
From: "Luck, Tony" <tony.luck@intel.com>
To: feng.tang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, hpa@zytor.com, jacob.jun.pan@intel.com, dtor@mail.ru,
       randy.dunlap@oracle.com
Cc: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH v2 5/5] input: i8042 - add runtime check in x86's i8042_platform_init
In-Reply-To: <1278342202-10973-6-git-send-email-feng.tang@intel.com>
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com>
Date: Wed, 07 Jul 2010 13:02:16 -0700
Message-Id: <4c34dd482753bb8f1@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Tang <feng.tang@intel.com>

Then it will first check x86_platforms's i8042 detection result,
then go on with normal probe.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Added #ifdef around #include <asm/x86_init.h> -- Tony

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
