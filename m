Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab1JSRGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab1JSRGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:06:51 -0400
Date: Wed, 19 Oct 2011 13:06:42 -0400
From: Dave Jones <davej@redhat.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: ACPI: Add Sony VGN-FW21E to nonvs blacklist.
Message-ID: <20111019170642.GD2116@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Len Brown <lenb@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As noted by a user in https://bugzilla.redhat.com/show_bug.cgi?id=641789
The Sony VGN-FW21E also needs the nonvs by default workaround added.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 3ed80b2..17fc718 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -390,6 +390,14 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW21E",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21E"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VGN-SR11M",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
