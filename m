Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1GTU6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:58:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42631 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GTU6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:58:41 -0400
From: Thomas Courbon <thcourbon@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Courbon <thcourbon@gmail.com>
Subject: [PATCH 1/1] Platform: fix samsung-laptop DMI identification for N150/N210/220/N230
Date: Wed, 20 Jul 2011 22:57:44 +0200
Message-Id: <1311195464-12605-1-git-send-email-thcourbon@gmail.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some samsung latop of the N150/N2{10,20,30} serie are badly detected by the samsung-laptop platform driver, see bug # 36082.
It appears that N230 identifies itself as N150/N210/N220/N230 whereas the other identify themselves as N150/N210/220.
This patch attemtp fix #36082 allowing correct identification for all the said netbook model.

Reported-by: Daniel Eklöf <daniel@ekloef.se>
Signed-off-by: Thomas Courbon <thcourbon@gmail.com>
---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d347116..bd61898 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -601,6 +601,16 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "N150/N210/N220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR,
+					"SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N150/N210/N220"),
+			DMI_MATCH(DMI_BOARD_NAME, "N150/N210/N220"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "N150/N210/N220/N230",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR,
-- 
1.7.6

