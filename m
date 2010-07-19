Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852Ab0GSRpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:45:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56577 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab0GSRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:45:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@lists.ubuntu.com, Kamal Mostafa <kamal@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Elliott Sales de Andrade <quantum.analyst@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-input@vger.kernel.org
Subject: [PATCH] i8042: add Gigabyte Spring Peak to dmi_noloop_table
Date: Mon, 19 Jul 2010 10:45:34 -0700
Message-Id: <1279561534-3551-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gigabyte "Spring Peak" notebook indicates wrong chassis-type, tripping up
i8042 and breaking the touchpad.  Add this model to i8042_dmi_noloop_table[]
to resolve.

BugLink: https://bugs.launchpad.net/bugs/580664

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: <stable@kernel.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 6168469..d953d65 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -166,6 +166,13 @@ static const struct dmi_system_id __initconst i8042_dmi_noloop_table[] = {
 		},
 	},
 	{
+		/* Gigabyte Spring Peak */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "GIGABYTE"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Spring Peak"),
+		},
+	},
+	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv9700"),
-- 
1.7.0.4

