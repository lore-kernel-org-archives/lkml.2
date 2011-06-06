Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1FFVWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:22:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36112 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FFVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:22:04 -0400
Date: Mon, 6 Jun 2011 21:21:58 GMT
From: tip-bot for Matthew Garrett <mjg@redhat.com>
Message-ID: <tip-f7a2d73fe75c71941fb0a6b4d8fe7da8144f2c7b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1307388985-7852-1-git-send-email-mjg@redhat.com>
References: <1307388985-7852-1-git-send-email-mjg@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Fix argument types for SetVariable()
Git-Commit-ID: f7a2d73fe75c71941fb0a6b4d8fe7da8144f2c7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Jun 2011 21:21:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7a2d73fe75c71941fb0a6b4d8fe7da8144f2c7b
Gitweb:     http://git.kernel.org/tip/f7a2d73fe75c71941fb0a6b4d8fe7da8144f2c7b
Author:     Matthew Garrett <mjg@redhat.com>
AuthorDate: Mon, 6 Jun 2011 15:36:24 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 6 Jun 2011 13:30:27 -0700

x86, efi: Fix argument types for SetVariable()

The spec says this takes uint32 for attributes, not uintn.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Link: http://lkml.kernel.org/r/1307388985-7852-1-git-send-email-mjg@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
