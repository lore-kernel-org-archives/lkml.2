Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0FUNbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:31:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38046 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab0FUNbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:31:33 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <lenb@kernel.org>, Alex Chiang <achiang@hp.com>,
       Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI dock: move some functions to .init.text
Date: Mon, 21 Jun 2010 15:31:13 +0200
Message-Id: <1277127073-10485-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100618073950.GA12822@pengutronix.de>
References: <20100618073950.GA12822@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are some of the few stoppers of moving
platform_device_register_data to .init.text, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/acpi/dock.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 3fe29e9..2b16563 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -929,7 +929,7 @@ static struct attribute_group dock_attribute_group = {
  * allocated and initialize a new dock station device.  Find all devices
  * that are on the dock station, and register for dock event notifications.
  */
-static int dock_add(acpi_handle handle)
+static int __init dock_add(acpi_handle handle)
 {
 	int ret, id;
 	struct dock_station ds, *dock_station;
@@ -1023,7 +1023,7 @@ static int dock_remove(struct dock_station *ds)
  *
  * This is called by acpi_walk_namespace to look for dock stations.
  */
-static acpi_status
+static __init acpi_status
 find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	if (is_dock(handle))
@@ -1032,7 +1032,7 @@ find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
-static acpi_status
+static __init acpi_status
 find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	/* If bay is a dock, it's already handled */
-- 
1.7.1

