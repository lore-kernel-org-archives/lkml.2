Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2DXWBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:01:23 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3037 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab2DXWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:01:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1335304850!9576852!22
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mrst: quiet sparse noise about plain integer as NULL pointer
Date: Tue, 24 Apr 2012 15:00:53 -0700
User-Agent: KMail/1.9.9
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204241500.53685.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter to intel_scu_notifier_post is a void * not an integer.

This quiets the sparse noise:

arch/x86/platform/mrst/mrst.c:808:48: warning: Using plain integer as NULL pointer
arch/x86/platform/mrst/mrst.c:817:43: warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>

---

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index e0a3723..e31bcd8 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -805,7 +805,7 @@ void intel_scu_devices_create(void)
 		} else
 			i2c_register_board_info(i2c_bus[i], i2c_devs[i], 1);
 	}
-	intel_scu_notifier_post(SCU_AVAILABLE, 0L);
+	intel_scu_notifier_post(SCU_AVAILABLE, NULL);
 }
 EXPORT_SYMBOL_GPL(intel_scu_devices_create);
 
@@ -814,7 +814,7 @@ void intel_scu_devices_destroy(void)
 {
 	int i;
 
-	intel_scu_notifier_post(SCU_DOWN, 0L);
+	intel_scu_notifier_post(SCU_DOWN, NULL);
 
 	for (i = 0; i < ipc_next_dev; i++)
 		platform_device_del(ipc_devs[i]);
