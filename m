Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2J1X0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab2J1X0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:41 -0400
Message-Id: <20121028231538.053244344@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 003/105] samsung-laptop: make the dmi check less strict (part 2)
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 3be324a94df0c3f032178d04549dbfbf6cccb09a upstream.

These are the hunks that I dropped when backporting for 3.2.24,
which are applicable now that we also have commit f34cd9ca
('samsung-laptop: don't handle backlight if handled by acpi/video').

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -608,10 +608,8 @@ static int __init samsung_init(void)
 
 #ifdef CONFIG_ACPI
 	/* Don't handle backlight here if the acpi video already handle it */
-	if (acpi_video_backlight_support()) {
-		pr_info("Backlight controlled by ACPI video driver\n");
+	if (acpi_video_backlight_support())
 		handle_backlight = false;
-	}
 #endif
 
 	if (!force && !dmi_check_system(samsung_dmi_table))
@@ -695,6 +693,12 @@ static int __init samsung_init(void)
 	if (handle_backlight)
 		check_for_stepping_quirk();
 
+#ifdef CONFIG_ACPI
+	/* Only log that if we are really on a sabi platform */
+	if (acpi_video_backlight_support())
+		pr_info("Backlight controlled by ACPI video driver\n");
+#endif
+
 	/* knock up a platform device to hang stuff off of */
 	sdev = platform_device_register_simple("samsung", -1, NULL, 0);
 	if (IS_ERR(sdev))


