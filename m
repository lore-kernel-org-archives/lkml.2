Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1C2UtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:49:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54170
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754138Ab1C2UsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:10 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 06/07] Replaced DPRINT and printk with native functions in hv_utils
Date: Tue, 29 Mar 2011 13:58:49 -0700
Message-Id: <1301432330-1705-7-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced all DPRINT and printk calls with pr_ calls

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_kvp.c  |    6 +++---
 drivers/staging/hv/hv_util.c |   17 +++++++++--------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index 7775820..c71a148 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -20,7 +20,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/net.h>
 #include <linux/nls.h>
@@ -114,7 +114,7 @@ kvp_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 	message = (struct hv_ku_msg *)msg->data;
 	if (msg->seq == KVP_REGISTER) {
-		printk(KERN_INFO "KVP: user-mode registering done.\n");
+		pr_info("KVP: user-mode registering done.\n");
 		kvp_register();
 	}
 
@@ -174,7 +174,7 @@ kvp_respond_to_host(char *key, char *value, int error)
 		/*
 		 * This is a spurious call!
 		 */
-		printk(KERN_WARNING "KVP: Transaction not active\n");
+		pr_warn("KVP: Transaction not active\n");
 		return;
 	}
 	/*
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 3e74f79..3af0a11 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -18,6 +18,8 @@
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -76,15 +78,15 @@ static void shutdown_onchannelcallback(void *context)
 				icmsghdrp->status = HV_S_OK;
 				execute_shutdown = true;
 
-				DPRINT_INFO(VMBUS, "Shutdown request received -"
-					    " gracefull shutdown initiated");
+				pr_info("Shutdown request received -"
+					    " gracefull shutdown initiated\n");
 				break;
 			default:
 				icmsghdrp->status = HV_E_FAIL;
 				execute_shutdown = false;
 
-				DPRINT_INFO(VMBUS, "Shutdown request received -"
-					    " Invalid request");
+				pr_info("Shutdown request received -"
+					    " Invalid request\n");
 				break;
 			};
 		}
@@ -242,7 +244,7 @@ MODULE_DEVICE_TABLE(dmi, hv_utils_dmi_table);
 
 static int __init init_hyperv_utils(void)
 {
-	printk(KERN_INFO "Registering HyperV Utility Driver\n");
+	pr_info("Registering HyperV Utility Driver\n");
 
 	if (hv_kvp_init())
 		return -ENODEV;
@@ -256,8 +258,7 @@ static int __init init_hyperv_utils(void)
 	hbeat_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!shut_txf_buf || !time_txf_buf || !hbeat_txf_buf) {
-		printk(KERN_INFO
-		       "Unable to allocate memory for receive buffer\n");
+		pr_info("Unable to allocate memory for receive buffer\n");
 		kfree(shut_txf_buf);
 		kfree(time_txf_buf);
 		kfree(hbeat_txf_buf);
@@ -286,7 +287,7 @@ static int __init init_hyperv_utils(void)
 
 static void exit_hyperv_utils(void)
 {
-	printk(KERN_INFO "De-Registered HyperV Utility Driver\n");
+	pr_info("De-Registered HyperV Utility Driver\n");
 
 	hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
 		&chn_cb_negotiate;
-- 
1.6.0.2

