Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2CLOSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:18:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63801 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2CLOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:18:20 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:staging:mei Fix some typos in staging/mei
Date: Mon, 12 Mar 2012 07:18:09 -0700
Message-Id: <1331561889-19488-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos in drivers/staging/mei/* that I have found while
doing a little bit of reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/mei/interface.c       |    2 +-
 drivers/staging/mei/interface.h       |    2 +-
 drivers/staging/mei/interrupt.c       |    6 +++---
 drivers/staging/mei/iorw.c            |    4 ++--
 drivers/staging/mei/main.c            |    4 ++--
 drivers/staging/mei/mei-amt-version.c |    2 +-
 drivers/staging/mei/mei.h             |    2 +-
 drivers/staging/mei/mei.txt           |    6 +++---
 drivers/staging/mei/mei_dev.h         |    2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/mei/interface.c b/drivers/staging/mei/interface.c
index a873be7..8a80e80 100644
--- a/drivers/staging/mei/interface.c
+++ b/drivers/staging/mei/interface.c
@@ -275,7 +275,7 @@ int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
  * @returns
  *	0 on success
  *	-ENOENT when me client is not found
- *	-EINVAL wehn ctrl credits are <= 0
+ *	-EINVAL when ctrl credits are <= 0
  */
 int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl)
 {
diff --git a/drivers/staging/mei/interface.h b/drivers/staging/mei/interface.h
index e5bfb18..fb90c6f 100644
--- a/drivers/staging/mei/interface.h
+++ b/drivers/staging/mei/interface.h
@@ -60,7 +60,7 @@ void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout);
  */
 void mei_watchdog_register(struct mei_device *dev);
 /*
- * mei_watchdog_unregister  - Uegistering watchdog interface
+ * mei_watchdog_unregister  - Unregistering watchdog interface
  * @dev - mei device
  */
 void mei_watchdog_unregister(struct mei_device *dev);
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index ce14e39..47fa9e2 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -718,7 +718,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 				dev->me_client_index++;
 				dev->me_client_presentation_num++;
 
-				/** Send Client Propeties request **/
+				/** Send Client Properties request **/
 				res = mei_host_client_properties(dev);
 				if (res < 0) {
 					dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
@@ -1506,7 +1506,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	dev->host_hw_state = mei_hcsr_read(dev);
 
 	/* Ack the interrupt here
-	 * In case of MSI we don't go throuhg the quick handler */
+	 * In case of MSI we don't go through the quick handler */
 	if (pci_dev_msi_enabled(dev->pdev))
 		mei_reg_write(dev, H_CSR, dev->host_hw_state);
 
@@ -1542,7 +1542,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 			return IRQ_HANDLED;
 		}
 	}
-	/* check slots avalable for reading */
+	/* check slots available for reading */
 	slots = mei_count_full_read_slots(dev);
 	dev_dbg(&dev->pdev->dev, "slots =%08x  extra_write_index =%08x.\n",
 		slots, dev->extra_write_index);
diff --git a/drivers/staging/mei/iorw.c b/drivers/staging/mei/iorw.c
index a3fbac9..a6b9694 100644
--- a/drivers/staging/mei/iorw.c
+++ b/drivers/staging/mei/iorw.c
@@ -109,8 +109,8 @@ int mei_ioctl_connect_client(struct file *file,
 	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
 			dev->me_clients[i].props.max_msg_length);
 
-	/* if we're connecting to amthi client so we will use the exist
-	 * connection
+	/* if we're connecting to amthi client then we will use the
+	 * existing connection
 	 */
 	if (uuid_le_cmp(data->in_client_uuid, mei_amthi_guid) == 0) {
 		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 22afc92..64456ce 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -430,7 +430,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto free;
 	} else if ((!cl->read_cb || !cl->read_cb->information) &&
 		    *offset > 0) {
-		/*Offset needs to be cleaned for contingous reads*/
+		/*Offset needs to be cleaned for contiguous reads*/
 		*offset = 0;
 		rets = 0;
 		goto out;
@@ -493,7 +493,7 @@ copy_buffer:
 		goto free;
 	}
 
-	/* length is being turncated to PAGE_SIZE, however, */
+	/* length is being truncated to PAGE_SIZE, however, */
 	/* information size may be longer */
 	length = min_t(size_t, length, (cb->information - *offset));
 
diff --git a/drivers/staging/mei/mei-amt-version.c b/drivers/staging/mei/mei-amt-version.c
index 970f2d3..ac2a507 100644
--- a/drivers/staging/mei/mei-amt-version.c
+++ b/drivers/staging/mei/mei-amt-version.c
@@ -77,7 +77,7 @@
 #include "mei.h"
 
 /*****************************************************************************
- * Intel Management Enginin Interface
+ * Intel Management Engine Interface
  *****************************************************************************/
 
 #define mei_msg(_me, fmt, ARGS...) do {         \
diff --git a/drivers/staging/mei/mei.h b/drivers/staging/mei/mei.h
index b09b11c..bc0d8b6 100644
--- a/drivers/staging/mei/mei.h
+++ b/drivers/staging/mei/mei.h
@@ -77,7 +77,7 @@
  * Only in close() (file_operation release()) the communication between
  * the clients is disconnected
  *
- * The IOCTL argument is a struct with a union the contains
+ * The IOCTL argument is a struct with a union that contains
  * the input parameter and the output parameter for this IOCTL.
  *
  * The input parameter is UUID of the FW Client.
diff --git a/drivers/staging/mei/mei.txt b/drivers/staging/mei/mei.txt
index 516bfe7..2785697 100644
--- a/drivers/staging/mei/mei.txt
+++ b/drivers/staging/mei/mei.txt
@@ -4,7 +4,7 @@ Intel(R) Management Engine Interface (Intel(R) MEI)
 Introduction
 =======================
 
-The Intel Management Engine (Intel ME) is an isolated andprotected computing
+The Intel Management Engine (Intel ME) is an isolated and protected computing
 resource (Co-processor) residing inside certain Intel chipsets. The Intel ME
 provides support for computer/IT management features. The feature set
 depends on the Intel chipset SKU.
@@ -176,8 +176,8 @@ Intel AMT OS Health Watchdog:
 =============================
 The Intel AMT Watchdog is an OS Health (Hang/Crash) watchdog.
 Whenever the OS hangs or crashes, Intel AMT will send an event
-to any subsciber to this event. This mechanism means that
-IT knows when a platform crashes even when there is a hard failureon the host.
+to any subscriber to this event. This mechanism means that
+IT knows when a platform crashes even when there is a hard failure on the host.
 
 The Intel AMT Watchdog is composed of two parts:
 	1) Firmware feature - receives the heartbeats
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index 0d937b0..10b1b4e 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -89,7 +89,7 @@ enum mei_states {
 	MEI_POWER_UP
 };
 
-/* init clients  states*/
+/* init clients states*/
 enum mei_init_clients_states {
 	MEI_START_MESSAGE = 0,
 	MEI_ENUM_CLIENTS_MESSAGE,
-- 
1.7.5.4

