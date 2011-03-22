Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1CVVCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:02:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:62642 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1CVVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:02:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVV7cZ5
X-RZG-CLASS-ID: mo00
Date: Tue, 22 Mar 2011 22:02:07 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: Reduce indention in vmbus_on_event
Message-ID: <20110322210207.GA17724@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce indention in vmbus_on_event() by converting two
if (var) to if (!var)

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 drivers/staging/hv/connection.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/staging/hv/connection.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/connection.c
+++ linux-2.6/drivers/staging/hv/connection.c
@@ -292,32 +292,25 @@ void vmbus_on_event(unsigned long data)
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
-						DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
+	if (!recv_int_page)
+		return;
+	for (dword = 0; dword < maxdword; dword++) {
+		if (!recv_int_page[dword])
+			continue;
+		for (bit = 0; bit < 32; bit++) {
+			if (sync_test_and_clear_bit(bit, (unsigned long *)&recv_int_page[dword])) {
+				relid = (dword << 5) + bit;
+				DPRINT_DBG(VMBUS, "event detected for relid - %d", relid);
 
-						if (relid == 0) {
-							/* special case - vmbus channel protocol msg */
-							DPRINT_DBG(VMBUS, "invalid relid - %d", relid);
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
+					DPRINT_DBG(VMBUS, "invalid relid - %d", relid);
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
