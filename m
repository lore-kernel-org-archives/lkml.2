Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab0DGHdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:33:32 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51545 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0DGHd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=w4lJL1Mpx+xPkgqquUe6cZRUxapFYN6EHxRHQDjKRdTH2NIkS+jfpvdL+93X/uJVbT
         beQCGhkLeiu/LLIewfqPO1M5GHODqA4fO3/HsYDGqqTag6AUb/FF68gXeNkVvtrnKT/Z
         kIcRxqYNCKCK3jwaQkiHPKl8Ht7rfarWpXlak=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: James.Bottomley@suse.de, james.smart@emulex.com, bharrosh@panasas.com,
       linux-scsi@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH,RESENDv2] scsi: use __uX types for headers exported to user space
Date: Wed,  7 Apr 2010 09:33:10 +0200
Message-Id: <1270625590-21164-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e4f5e29 (FC Pass Thru support) exported a number of header files
in include/scsi to user space, but didn't change the uX types to the
userspace-compatible __uX types. Without that you'll get compile errors
when including them - E.G.:

/tmp/include/scsi/scsi.h:145: error: expected specifier-qualifier-list
before ‘u8’

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
- It seems like this didn't get committed after the last discussion, so
  resending: http://lkml.org/lkml/2010/1/7/154

- Dropped unneeded 2nd hunk of scsi_netlink.h as noted by Boaz Harrosh.

 include/scsi/scsi.h         |    8 ++++----
 include/scsi/scsi_netlink.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8b4deca..ec3053e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -149,10 +149,10 @@ struct scsi_cmnd;
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 536752c..58ce8fe 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -105,8 +105,8 @@ struct scsi_nl_host_vendor_msg {
  *    PCI :  ID data is the 16 bit PCI Registered Vendor ID
  */
 #define SCSI_NL_VID_TYPE_SHIFT		56
-#define SCSI_NL_VID_TYPE_MASK		((u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
-#define SCSI_NL_VID_TYPE_PCI		((u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_MASK		((__u64)0xFF << SCSI_NL_VID_TYPE_SHIFT)
+#define SCSI_NL_VID_TYPE_PCI		((__u64)0x01 << SCSI_NL_VID_TYPE_SHIFT)
 #define SCSI_NL_VID_ID_MASK		(~ SCSI_NL_VID_TYPE_MASK)
 
 
-- 
1.7.0

