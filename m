Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747Ab1DLRoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:44:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab1DLRoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:44:06 -0400
Date: Tue, 12 Apr 2011 13:44:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, mstowe@redhat.com, dnelson@redhat.com,
        tony.luck@intel.com, Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH]: mce: don't print "human readable" message for corrected errors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't display the "human readable" warning for correctable errors in mce.
There is no need for this information to be displayed.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 450a366..8024013 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -100,10 +100,16 @@ ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
 EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
 
 static int default_decode_mce(struct notifier_block *nb, unsigned long val,
-			       void *data)
+			      void *data)
 {
-	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
-	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
+	struct mce *m = (struct mce *)data;
+
+	if (m->status & MCI_STATUS_UC) {
+		pr_emerg(HW_ERR "No human readable MCE decoding support "
+			 "on this CPU type.\n");
+		pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' "
+			 "to decode.\n");
+	}
 
 	return NOTIFY_STOP;
 }
