Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab2L1TTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55431 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274Ab2L1TTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:03 -0500
Message-Id: <20121228190345.895158805@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lan Tianyu <tianyu.lan@intel.com>,
        =?ISO-8859-15?q?S=C3=A9bastien=20Wilmet?= <swilmet@gnome.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 075/173] ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 876ab79055019e248508cfd0dee7caa3c0c831ed upstream.

Sony Vaio VPCEB1S1E does not resume correctly without
acpi_sleep=nonvs, so add it to the ACPI sleep blacklist.

References: https://bugzilla.kernel.org/show_bug.cgi?id=48781
Reported-by: Sébastien Wilmet <swilmet@gnome.org>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 8640782..1463c56 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -534,6 +534,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCEB1S1E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCEB1S1E"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-FW520F",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),


