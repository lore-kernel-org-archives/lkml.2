Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2L1TSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:18:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55330 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144Ab2L1TSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:34 -0500
Message-Id: <20121228190351.852950981@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:13 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>, Stefan Nagy <public@stefan-nagy.at>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 103/173] ACPI / video: ignore BIOS initial backlight value for HP Folio
 13-2000
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 129ff8f8d58297b04f47b5d6fad81aa2d08404e1 upstream.

Or else the laptop will boot with a dimmed screen.

References: https://bugzilla.kernel.org/show_bug.cgi?id=51141
Tested-by: Stefan Nagy <public@stefan-nagy.at>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/video.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 0230cb6..ac9a69c 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -389,6 +389,12 @@ static int __init video_set_bqc_offset(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int video_ignore_initial_backlight(const struct dmi_system_id *d)
+{
+	use_bios_initial_backlight = 0;
+	return 0;
+}
+
 static struct dmi_system_id video_dmi_table[] __initdata = {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=13121
@@ -433,6 +439,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 7720"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Folio 13-2000",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
+		},
+	},
 	{}
 };
 


