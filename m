Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1HBU5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:57:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:28107 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab1HBU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="34420284"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Mike Waychison" <mikew@google.com>, "Matthew Garrett" <mjg@redhat.com>
Subject: [PATCH] efivars: fix warnings when CONFIG_PSTORE=n
Date: Tue, 02 Aug 2011 13:57:06 -0700
Message-Id: <4e3864a227625bd7d6@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/firmware/efivars.c:161: warning: ‘utf16_strlen’ defined but not used
utf16_strlen() is only used inside CONFIG_PSTORE - put same #ifdef around the
definition of the function too.

drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type
Between v1 and v2 of this patch series we decided to make the "part" number
unsigned - but missed fixing the stub version of efi_pstore_write()

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eacb05e..5315c1e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -157,11 +157,13 @@ utf16_strnlen(efi_char16_t *s, size_t maxlength)
 	return length;
 }
 
+#ifdef CONFIG_PSTORE
 static unsigned long
 utf16_strlen(efi_char16_t *s)
 {
 	return utf16_strnlen(s, ~0UL);
 }
+#endif
 
 /*
  * Return the number of bytes is the length of this string
@@ -580,8 +582,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	return -1;
 }
 
-static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
-			    struct pstore_info *psi)
+static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
+			    size_t size, struct pstore_info *psi)
 {
 	return 0;
 }
