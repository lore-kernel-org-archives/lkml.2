Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946502Ab2ERXFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946476Ab2ERXE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:56 -0400
Message-Id: <20120518211603.685622769@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lan Tianyu <tianyu.lan@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [ 46/54] ACPI / PM: Add Sony Vaio VPCCW29FX to nonvs blacklist.
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 93f770846e8dedc5d9117bd4ad9d7efd18420627 upstream.

Sony Vaio VPCCW29FX does not resume correctly without
acpi_sleep=nonvs, so add it to the ACPI sleep blacklist.

https://bugzilla.kernel.org/show_bug.cgi?id=34722

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -422,6 +422,14 @@ static struct dmi_system_id __initdata a
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VPCCW29FX",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VPCCW29FX"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Averatec AV1020-ED2",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "AVERATEC"),


