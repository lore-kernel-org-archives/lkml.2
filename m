Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2GASQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756022Ab2GASQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:45 -0400
Message-Id: <20120701172011.094939158@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Lekensteyn <lekensteyn@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 31/48] iwlwifi: remove log_event debugfs file debugging is disabled
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 882b7b7d11d65e8eccce738f1ce97cdfdb998f9f upstream.

When debugging is disabled, the event log functions aren't
functional in the way that the debugfs file expects. This
leads to the debugfs access crashing. Since the event log
functions aren't functional then, remove the debugfs file
when CONFIG_IWLWIFI_DEBUG is not set.

Reported-by: Lekensteyn <lekensteyn@gmail.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1777,6 +1777,7 @@
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -1814,6 +1815,7 @@
 
 	return count;
 }
+#endif
 
 static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 					char __user *user_buf,
@@ -1941,7 +1943,9 @@
 	return ret;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+#endif
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -1957,7 +1961,9 @@
 {
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+#ifdef CONFIG_IWLWIFI_DEBUG
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
+#endif
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);


