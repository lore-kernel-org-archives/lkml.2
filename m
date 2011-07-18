Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1GRIIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:08:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40501 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:08:29 -0400
Subject: [PATCH] platform-drivers-x86: samsung-q10: make dmi_check_callback
 return 1
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Frederick van der Wyck <fvanderwyck@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 16:08:21 +0800
Message-ID: <1310976501.20944.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only care about if there is any successful match from the dmi table
or no match at all, we can make dmi_check_system return immediately if
we have a successful match instead of iterate thorough the whole table.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/samsung-q10.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
index 54cf3d6..1e54ae7 100644
--- a/drivers/platform/x86/samsung-q10.c
+++ b/drivers/platform/x86/samsung-q10.c
@@ -127,7 +127,7 @@ static struct platform_device *samsungq10_device;
 static int __init dmi_check_callback(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": found model '%s'\n", id->ident);
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata samsungq10_dmi_table[] = {
-- 
1.7.4.1



