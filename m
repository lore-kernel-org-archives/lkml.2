Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1GUVBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1GUVAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:00:02 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, mikew@google.com, tony.luck@intel.com
Subject: [PATCH V2 7/9] efivars: introduce utf16_strncmp
Date: Thu, 21 Jul 2011 16:57:58 -0400
Message-Id: <1311281880-28041-8-git-send-email-mjg@redhat.com>
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Introduce utf16_strncmp which is used in the next patch.  Semantics
should be the same as the strncmp C function.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 4202a31..15b9a01 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -169,6 +169,24 @@ utf16_strsize(efi_char16_t *data, unsigned long maxlength)
 	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
 }
 
+static inline int
+utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
+{
+	while (1) {
+		if (len == 0)
+			return 0;
+		if (*a < *b)
+			return -1;
+		if (*a > *b)
+			return 1;
+		if (*a == 0) /* implies *b == 0 */
+			return 0;
+		a++;
+		b++;
+		len--;
+	}
+}
+
 static efi_status_t
 get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
 {
-- 
1.7.6

