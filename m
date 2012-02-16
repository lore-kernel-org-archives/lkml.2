Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2BPN67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab2BPN66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:58:58 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, hpa@zytor.com, Matthew Garrett <mjg@redhat.com>,
        stable@kernel.org
Subject: [PATCH 1/2] efi: Add new variable attributes
Date: Thu, 16 Feb 2012 08:58:36 -0500
Message-Id: <1329400717-22670-1-git-send-email-mjg@redhat.com>
X-cavan-blacklisted-at: zen.spamhaus.org
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 208.54.36.171
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More recent versions of the UEFI spec have added new attributes for
variables. Add them.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@kernel.org
---
 include/linux/efi.h |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..7cce0ea 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -510,7 +510,18 @@ extern int __init efi_setup_pcdp_console(char *);
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
1.7.7.6

