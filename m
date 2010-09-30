Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0I3Krw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:47:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41989 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0I3Krs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LPIrbyLaTSuJ4zXH9QSBA/CJinzDa/fKC2Cqx+12NCnImNpXWGygOQhvZjyVtSm+HV
         VeJM6MeJGzxW3JbyKxSAtxtvCMbl6qnEYZi84bpQLDYe1vJKhYeDhxzBLr+HUvxJMyJS
         K9jrZ5C6GqR6ljwrHf1kJifTempw8dPusoQB0=
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: lenb@kernel.org, rui.zhang@intel.com
Cc: melchior+kernel@cmu.edu, jerone.young@canonical.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patrol@sinus.cz, "Lee, Chun-Yi" <jlee@novell.com>
Subject: [PATCH] DMI to disable Vista compatibility on MSI GX723 Notebook
Date: Thu, 30 Sep 2010 18:44:11 +0800
Message-Id: <1285843451-24932-1-git-send-email-jlee@novell.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness control hotkey don't work with Vista compatibility
, because MSI GX723 included a infinite while loop in DSDT when
brightness control hotkey pressed.
MSI GX723 used Nvida video card, the infinite while loop must be a
workaround with Nvidia's Vista driver.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 2bb28b9..3e644d8 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -226,6 +226,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		},
 	},
 	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "MSI GX723",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star International"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "GX723"),
+		},
+	},
+	{
 	.callback = dmi_disable_osi_win7,
 	.ident = "ASUS K50IJ",
 	.matches = {
-- 
1.6.0.2

