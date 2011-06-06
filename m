Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1FFUUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:20:25 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:26493 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1FFUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:20:24 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-127.messagelabs.com!1307391608!21640262!11
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Date: Mon, 6 Jun 2011 13:19:45 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106061319.45855.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of the procfs and debugfs attribute file_operations in the kernel are
missing the .owner information. Introduce some macro's to fill in the .owner
field as well as the common methods for virtual file file_operations.  This
simplifies creating the attributes and makes sure all the fields are properly
initialized.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 03c0232..6a1f991 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -153,4 +153,28 @@ extern struct hlist_node *seq_hlist_start_head_rcu(struct hlist_head *head,
 extern struct hlist_node *seq_hlist_next_rcu(void *v,
 						   struct hlist_head *head,
 						   loff_t *ppos);
+
+/*
+ * virtual filesystem attribute files
+ */
+
+#define DECLARE_SEQ_FOPS_RO(name)			\
+static const struct file_operations name##_fops = {	\
+	.owner		= THIS_MODULE,			\
+	.llseek		= seq_lseek,			\
+	.read		= seq_read,			\
+	.open		= name##_open,			\
+	.release	= single_release,		\
+}
+
+#define DECLARE_SEQ_FOPS_RW(name)			\
+static const struct file_operations name##_fops = {	\
+	.owner		= THIS_MODULE,			\
+	.llseek		= seq_lseek,			\
+	.read		= seq_read,			\
+	.write		= name##_write,			\
+	.open		= name##_open,			\
+	.release	= single_release,		\
+}
+
 #endif
