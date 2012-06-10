Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab2FJJ2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:28:10 -0400
Received: from mail.wybt.net ([195.191.196.3]:58089 "EHLO
	mail.wouldyoubuythis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2FJJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:28:08 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2012 05:28:08 EDT
Date: Sun, 10 Jun 2012 13:18:41 +0400
From: Vsevolod Kozlov <zaba@wybt.net>
To: linux-kernel@vger.kernel.org
Subject: thinkpad_acpi: Saving bluetooth state to NVRAM problem and fix
Message-ID: <20120610091840.GA4960@scharfenberg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thinkpad_acpi normally fails to save Bluetooth state to NVRAM on my system
(ThinkPad X120e).  However, a small change in the code fixes the functionality:

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3999,7 +3999,7 @@ static const struct tpacpi_rfk_ops bluetooth_tprfk_ops = {
 static void bluetooth_shutdown(void)
 {
 	/* Order firmware to save current state to NVRAM */
-	if (!acpi_evalf(NULL, NULL, "\\BLTH", "vd",
+	if (!acpi_evalf(NULL, NULL, "\\_SB.BLTH", "vd",
 			TP_ACPI_BLTH_SAVE_STATE))
 		pr_notice("failed to save bluetooth state to NVRAM\n");
 	else

I can't tell whether this breaks the functionality on other ThinkPad systems
because I don't have any, though.

Please CC me any responses, as I am not subscribed to the list.

Regards,

-- 
Zaba
