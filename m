Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758Ab2LNXFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:05:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:41121 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684Ab2LNXFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:05:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?S=C3=A9bastien=20Wilmet?= <swilmet@gnome.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 14/27] ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
Date: Fri, 14 Dec 2012 15:01:27 -0800
Message-Id: <20121214222254.558516474@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 876ab79055019e248508cfd0dee7caa3c0c831ed upstream.

Sony Vaio VPCEB1S1E does not resume correctly without
acpi_sleep=nonvs, so add it to the ACPI sleep blacklist.

References: https://bugzilla.kernel.org/show_bug.cgi?id=48781
Reported-by: Sébastien Wilmet <swilmet@gnome.org>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/sleep.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -519,6 +519,14 @@ static struct dmi_system_id __initdata a
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


