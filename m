Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab0EECIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:08:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:36914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933810Ab0EECIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:08:41 -0400
Date: Wed, 5 May 2010 02:08:12 GMT
From: "tip-bot for Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <1269936436-7039-6-git-send-email-ebiederm@xmission.com>
References: <1269936436-7039-6-git-send-email-ebiederm@xmission.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, ioapic: Only export mp_find_ioapic and mp_find_ioapic_pin in io_apic.h
Message-ID: <tip-9638fa521e42c9281c874c6b5a382b1ced4ee496@git.kernel.org>
Git-Commit-ID: 9638fa521e42c9281c874c6b5a382b1ced4ee496
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 02:08:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9638fa521e42c9281c874c6b5a382b1ced4ee496
Gitweb:     http://git.kernel.org/tip/9638fa521e42c9281c874c6b5a382b1ced4ee496
Author:     Eric W. Biederman <ebiederm@xmission.com>
AuthorDate: Tue, 30 Mar 2010 01:07:07 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 13:34:44 -0700

x86, ioapic: Only export mp_find_ioapic and mp_find_ioapic_pin in io_apic.h

Multiple declarations of the same function in different headers
is a pain to maintain.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <1269936436-7039-6-git-send-email-ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mpspec.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index d8bf23a..29994f0 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -106,10 +106,6 @@ struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
 extern int acpi_probe_gsi(void);
-#ifdef CONFIG_X86_IO_APIC
-extern int mp_find_ioapic(int gsi);
-extern int mp_find_ioapic_pin(int ioapic, int gsi);
-#endif
 #else /* !CONFIG_ACPI: */
 static inline int acpi_probe_gsi(void)
 {
