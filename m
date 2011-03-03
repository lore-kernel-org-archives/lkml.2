Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448Ab1CCOBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:01:14 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58655 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab1CCOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:01:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jX91/xq3bDxTHly/rny7koa9RpSeqlIIBx10K6YplN9H0t5BPal1vr3v2sTMtXSlpM
         xPALbo+f9VOAWVNK0hGSoj9/aJrKb9DOtUjBgghQN+8q3ZIbWKXRO7kjMhdt3yjLgXvr
         ojMm3Gi6HJLionT5NBH2kv2fAo/ZuHOA+uLa0=
Date: Thu, 3 Mar 2011 22:01:01 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/05] sysctl: add proc_dointvec_unsigned handler
Message-ID: <20110303140101.GD2620@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add proc_dointvec_unsigned sysctl handler for positive value cases

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/sysctl.h |    2 ++
 kernel/sysctl.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

--- linux-2.6.orig/kernel/sysctl.c	2011-03-03 11:17:21.796661240 +0800
+++ linux-2.6/kernel/sysctl.c	2011-03-03 11:17:39.126661201 +0800
@@ -2459,6 +2459,32 @@ int proc_dointvec_bool(struct ctl_table 
 }
 EXPORT_SYMBOL(proc_dointvec_bool);
 
+/**
+ * proc_dointvec_unsigned - read a vector of integers with positive values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * This routine will ensure the values are positive.
+ *
+ * Returns 0 on success.
+ */
+int proc_dointvec_unsigned(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = &zero,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dointvec_minmax_conv, &param);
+}
+EXPORT_SYMBOL(proc_dointvec_unsigned);
+
 static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
 				     void __user *buffer,
 				     size_t *lenp, loff_t *ppos,
--- linux-2.6.orig/include/linux/sysctl.h	2011-03-03 11:16:16.000000000 +0800
+++ linux-2.6/include/linux/sysctl.h	2011-03-03 11:18:15.529994450 +0800
@@ -972,6 +972,8 @@ extern int proc_dointvec_minmax(struct c
 				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_bool(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_dointvec_unsigned(struct ctl_table *, int,
+				void __user *, size_t *, loff_t *);
 extern int proc_dointvec_jiffies(struct ctl_table *, int,
 				 void __user *, size_t *, loff_t *);
 extern int proc_dointvec_userhz_jiffies(struct ctl_table *, int,
