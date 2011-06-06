Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab1FFTgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:36:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757868Ab1FFTgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:36:51 -0400
From: Matthew Garrett <mjg@redhat.com>
To: x86@kernel.org
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/2] efi: Fix argument types for SetVariable()
Date: Mon,  6 Jun 2011 15:36:24 -0400
Message-Id: <1307388985-7852-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec says this takes uint32 for attributes, not uintn.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/platform/efi/efi.c |    2 +-
 include/linux/efi.h         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0d3a4fa..f4f6de9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -122,7 +122,7 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  efi_guid_t *vendor,
-					  unsigned long attr,
+					  u32 attr,
 					  unsigned long data_size,
 					  void *data)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e376270..0758753 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -168,7 +168,7 @@ typedef efi_status_t efi_get_variable_t (efi_char16_t *name, efi_guid_t *vendor,
 typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char16_t *name,
 					      efi_guid_t *vendor);
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
-					 unsigned long attr, unsigned long data_size, 
+					 u32 attr, unsigned long data_size,
 					 void *data);
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
-- 
1.7.5.2

