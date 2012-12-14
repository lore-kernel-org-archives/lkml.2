Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2LNXEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:04:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:40899 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2LNXER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:04:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Williamson <alex.williamson@redhat.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 27/37] ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist
Date: Fri, 14 Dec 2012 15:01:04 -0800
Message-Id: <20121214222257.653462511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit d0c2ce16bec0afa6013b4c5220ca4c9c67210215 upstream.

The ACPI video driver can't control backlight correctly on
Asus UL30VT.  Vendor driver (asus-laptop) can work.  This patch is to
add "Asus UL30VT" to ACPI video detect blacklist in order to use
asus-laptop for video control on the "Asus UL30VT" rather than ACPI
video driver.

References: https://bugzilla.kernel.org/show_bug.cgi?id=32592
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -156,6 +156,14 @@ static struct dmi_system_id video_detect
 		DMI_MATCH(DMI_BOARD_NAME, "X360"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30VT",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
+		},
+	},
 	{ },
 };
 


