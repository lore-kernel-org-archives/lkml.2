Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab0LMRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:10:52 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:45239 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0LMRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:10:50 -0500
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, RESEND 2/2] kbuild: export linux/{a.out,kvm,kvm_para}.h on headers_install_all
Date: Mon, 13 Dec 2010 19:10:29 +0200
Message-Id: <1292260229-10008-2-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292260229-10008-1-git-send-email-kirill@shutemov.name>
References: <1292260229-10008-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

Export linux/a.out.h, linux/kvm.h and linux/kvm_para.h on
headers_install_all if at least one architecture has appropriate files
in arch-dependent headers.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/Kbuild |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 97319a8..ae31f95 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -20,15 +20,18 @@ header-y += wimax/
 objhdr-y += version.h
 
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+		  $(srctree)/include/asm-$(SRCARCH)/a.out.h \
+		  $(INSTALL_HDR_PATH)/include/asm-*/a.out.h),)
 header-y += a.out.h
 endif
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+		  $(srctree)/include/asm-$(SRCARCH)/kvm.h \
+		  $(INSTALL_HDR_PATH)/include/asm-*/kvm.h),)
 header-y += kvm.h
 endif
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
-		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
+		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h \
+		  $(INSTALL_HDR_PATH)/include/asm-*/kvm_para.h),)
 header-y += kvm_para.h
 endif
 
-- 
1.7.3.3

