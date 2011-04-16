Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1DPQvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:50045 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1DPQuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:50:50 -0400
Message-Id: <20110416165042.416376417@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:39 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/5] hv: Reduce indention in vmbus_on_event                                                                                                                                                           
References: <20110416165038.986214764@aepfle.de>
Content-Disposition: inline; filename=bug679942-vmbus_on_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce indention in vmbus_on_event() by converting two
if (var) to if (!var)

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested.

 drivers/staging/hv/connection.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

Index: linux-next/drivers/staging/hv/connection.c
===================================================================
--- linux-next.orig/drivers/staging/hv/connection.c
+++ linux-next/drivers/staging/hv/connection.c
@@ -287,30 +287,23 @@ void vmbus_on_event(unsigned long data)
 	u32 *recv_int_page = vmbus_connection.recv_int_page;
 
 	/* Check events */
-	if (recv_int_page) {
-		for (dword = 0; dword < maxdword; dword++) {
-			if (recv_int_page[dword]) {
-				for (bit = 0; bit < 32; bit++) {
-					if (sync_test_and_clear_bit(bit,
-						(unsigned long *)
-						&recv_int_page[dword])) {
-						relid = (dword << 5) + bit;
+	if (!recv_int_page)
+		return;
+	for (dword = 0; dword < maxdword; dword++) {
+		if (!recv_int_page[dword])
+			continue;
+		for (bit = 0; bit < 32; bit++) {
+			if (sync_test_and_clear_bit(bit, (unsigned long *)&recv_int_page[dword])) {
+				relid = (dword << 5) + bit;
 
-						if (relid == 0) {
-							/* special case - vmbus channel protocol msg */
-							continue;
-						} else {
-							/* QueueWorkItem(VmbusProcessEvent, (void*)relid); */
-							/* ret = WorkQueueQueueWorkItem(gVmbusConnection.workQueue, VmbusProcessChannelEvent, (void*)relid); */
-						process_chn_event((void *)
-						(unsigned long)relid);
-						}
-					}
+				if (relid == 0) {
+					/* special case - vmbus channel protocol msg */
+					continue;
 				}
+				process_chn_event((void *) (unsigned long)relid);
 			}
-		 }
+		}
 	}
-	return;
 }
 
 /*

