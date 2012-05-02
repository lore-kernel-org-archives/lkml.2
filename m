Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab2EBSyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 14:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab2EBSya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 14:54:30 -0400
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH V2 1/2] efi: Add new variable attributes
Date: Wed,  2 May 2012 14:54:13 -0400
Message-Id: <1335984854-24690-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More recent versions of the UEFI spec have added new attributes for
variables. Add them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@vger.kernel.org
---
 include/linux/efi.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 88ec806..ec45ccd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -554,7 +554,18 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_VARIABLE_NON_VOLATILE       0x0000000000000001
 #define EFI_VARIABLE_BOOTSERVICE_ACCESS 0x0000000000000002
 #define EFI_VARIABLE_RUNTIME_ACCESS     0x0000000000000004
-
+#define EFI_VARIABLE_HARDWARE_ERROR_RECORD 0x0000000000000008
+#define EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS 0x0000000000000010
+#define EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS 0x0000000000000020
+#define EFI_VARIABLE_APPEND_WRITE	0x0000000000000040
+
+#define EFI_VARIABLE_MASK 	(EFI_VARIABLE_NON_VOLATILE | \
+				EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+				EFI_VARIABLE_RUNTIME_ACCESS | \
+				EFI_VARIABLE_HARDWARE_ERROR_RECORD | \
+				EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
+				EFI_VARIABLE_APPEND_WRITE)
 /*
  * The type of search to perform when calling boottime->locate_handle
  */
-- 
1.7.10

