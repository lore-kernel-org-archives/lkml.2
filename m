Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1GEM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:57:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab1GEM5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:57:39 -0400
Date: Tue, 5 Jul 2011 12:57:28 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Message-ID: <tip-d80603c9d876efafd8b07469c891076de470e323@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4E13100A020000780004C256@nat28.tlf.novell.com>
References: <4E13100A020000780004C256@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Properly pre-initialize table pointers
Git-Commit-ID: d80603c9d876efafd8b07469c891076de470e323
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:57:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d80603c9d876efafd8b07469c891076de470e323
Gitweb:     http://git.kernel.org/tip/d80603c9d876efafd8b07469c891076de470e323
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 5 Jul 2011 12:22:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 Jul 2011 13:40:34 +0200

x86, efi: Properly pre-initialize table pointers

Consumers of the table pointers in struct efi check for
EFI_INVALID_TABLE_ADDR to determine validity, hence these
pointers should all be pre-initialized to this value (rather
than zero).

Noticed by the discrepancy between efivars' systab sysfs entry
showing all tables (and their pointers) despite the code
intending to only display the valid ones. No other bad effects
known, but having the various table parsing routines bogusly
access physical address zero is certainly not very desirable
(even though they're unlikely to find anything useful there).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Link: http://lkml.kernel.org/r/4E13100A020000780004C256@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/efi/efi.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index a0e4244..11e766d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,7 +51,17 @@
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
 
-struct efi efi;
+struct efi __read_mostly efi = {
+	.mps        = EFI_INVALID_TABLE_ADDR,
+	.acpi       = EFI_INVALID_TABLE_ADDR,
+	.acpi20     = EFI_INVALID_TABLE_ADDR,
+	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.sal_systab = EFI_INVALID_TABLE_ADDR,
+	.boot_info  = EFI_INVALID_TABLE_ADDR,
+	.hcdp       = EFI_INVALID_TABLE_ADDR,
+	.uga        = EFI_INVALID_TABLE_ADDR,
+	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+};
 EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
