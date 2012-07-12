Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162333Ab2GLWpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:45:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62756 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162323Ab2GLWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lekensteyn <lekensteyn@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 162/187] iwlwifi: remove log_event debugfs file debugging is disabled
Date: Thu, 12 Jul 2012 15:35:18 -0700
Message-Id: <20120712191538.374631315@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2000,6 +2000,7 @@ static ssize_t iwl_dbgfs_rx_queue_read(s
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
@@ -2037,6 +2038,7 @@ static ssize_t iwl_dbgfs_log_event_write
 
 	return count;
 }
+#endif
 
 static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 					char __user *user_buf,
@@ -2164,7 +2166,9 @@ static ssize_t iwl_dbgfs_fh_reg_read(str
 	return ret;
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+#endif
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
@@ -2180,7 +2184,9 @@ static int iwl_trans_pcie_dbgfs_register
 {
 	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
+#ifdef CONFIG_IWLWIFI_DEBUG
 	DEBUGFS_ADD_FILE(log_event, dir, S_IWUSR | S_IRUSR);
+#endif
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);


