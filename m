Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1FUUSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:18:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:14175 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:18:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=QGB6ZIVfvbnQIG0A4q2szAoqkj4ZVVRCJ4HZn7tIXIf8HJYbtrApC9OKH8f0dMNpP
	KA7videYrWYj1UYthBQfQ==
From: Mike Waychison <mikew@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 2/4] efivars: introduce utf16_strncmp
Date: Tue, 21 Jun 2011 13:18:30 -0700
Message-Id: <1308687512-11649-2-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
References: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce utf16_strncmp which is used in the next patch.  Semantics
should be the same as the strncmp C function.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/efivars.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index f10c760..fb1219a 100644
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
1.7.3.1

