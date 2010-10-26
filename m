Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0JZBOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:14:48 -0400
Received: from beaker.bytemark.co.uk ([80.68.81.2]:38667 "EHLO
	beaker.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab0JZBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:12 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 20/30] staging/vme: trivial: rename vme_bus_num_mtx to vme_buses_lock
Date: Mon, 25 Oct 2010 21:11:06 -0400
Message-Id: <1288055476-19438-21-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

This paves the way for upcoming changes.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 59650dd..357748e 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -36,7 +36,7 @@
 
 /* Bitmask and mutex to keep track of bridge numbers */
 static unsigned int vme_bus_numbers;
-static DEFINE_MUTEX(vme_bus_num_mtx);
+static DEFINE_MUTEX(vme_buses_lock);
 
 static void __exit vme_exit(void);
 static int __init vme_init(void);
@@ -1307,7 +1307,7 @@ EXPORT_SYMBOL(vme_slot_get);
 
 /* - Bridge Registration --------------------------------------------------- */
 
-/* call with vme_bus_num_mtx held */
+/* call with vme_buses_lock held */
 static int __vme_alloc_bus_num(int *bus)
 {
 	int index;
@@ -1339,17 +1339,17 @@ static int vme_alloc_bus_num(int *bus)
 {
 	int ret;
 
-	mutex_lock(&vme_bus_num_mtx);
+	mutex_lock(&vme_buses_lock);
 	ret = __vme_alloc_bus_num(bus);
-	mutex_unlock(&vme_bus_num_mtx);
+	mutex_unlock(&vme_buses_lock);
 	return ret;
 }
 
 static void vme_free_bus_num(int bus)
 {
-	mutex_lock(&vme_bus_num_mtx);
+	mutex_lock(&vme_buses_lock);
 	vme_bus_numbers &= ~(0x1 << bus);
-	mutex_unlock(&vme_bus_num_mtx);
+	mutex_unlock(&vme_buses_lock);
 }
 
 /* Note: device_release(dev) throws a warning if dev->release isn't filled in */
-- 
1.7.1

