Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab2LNW1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:27:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:38127 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab2LNW1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:27:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stefan Nagy <public@stefan-nagy.at>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 17/22] ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000
Date: Fri, 14 Dec 2012 14:26:02 -0800
Message-Id: <20121214222253.798669214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 129ff8f8d58297b04f47b5d6fad81aa2d08404e1 upstream.

Or else the laptop will boot with a dimmed screen.

References: https://bugzilla.kernel.org/show_bug.cgi?id=51141
Tested-by: Stefan Nagy <public@stefan-nagy.at>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -390,6 +390,12 @@ static int __init video_set_bqc_offset(c
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
@@ -434,6 +440,14 @@ static struct dmi_system_id video_dmi_ta
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
 


