Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab2C2VQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:16:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33795 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933921Ab2C2VM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:57 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, Matthew Garrett <mjg59@srcf.ucam.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH 16/17] drivers/x86: mark const init data with __initconst instead of __initdata
Date: Thu, 29 Mar 2012 23:12:33 +0200
Message-Id: <1333055554-31300-16-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120329211131.GA31250@pengutronix.de>
References: <20120329211131.GA31250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as there is no other non-const variable marked __initdata in the
same compilation unit it doesn't hurt. If there were one however
compilation would fail with

	error: $variablename causes a section type conflict

because a section containing const variables is marked read only and so
cannot contain non-const variables.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: platform-driver-x86@vger.kernel.org
Cc: ibm-acpi-devel@lists.sourceforge.net
---
 drivers/platform/x86/dell-laptop.c   |    2 +-
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index a05fc9c..882bfa4 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -94,7 +94,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static const struct dmi_system_id __initdata dell_device_table[] = {
+static const struct dmi_system_id dell_device_table[] __initconst = {
 	{
 		.ident = "Dell laptop",
 		.matches = {
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d68c000..dc1900c 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -522,7 +522,7 @@ static acpi_handle ec_handle;
 
 #define TPACPI_HANDLE(object, parent, paths...)			\
 	static acpi_handle  object##_handle;			\
-	static const acpi_handle *object##_parent __initdata =	\
+	static const acpi_handle *object##_parent __initconst =	\
 						&parent##_handle; \
 	static char *object##_paths[] __initdata = { paths }
 
-- 
1.7.9.1

