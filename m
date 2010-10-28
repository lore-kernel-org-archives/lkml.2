Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab0J1NT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:19:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0J1NT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:19:26 -0400
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] kbuild: do not remove a.out kvm.h and kvm_para.h on headers_install_all
Date: Thu, 28 Oct 2010 16:19:10 +0300
Message-Id: <1288271950-17539-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

We really want to keep these headers if we want to get headers for all
architectures.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/Kbuild |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 831c463..8be1246 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -19,15 +19,17 @@ header-y += wimax/
 
 objhdr-y += version.h
 
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
+# KBUILD_HEADERS is needed to avoid removing these headers on headers_install_all
+
+ifneq ($(KBUILD_HEADERS)$(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
 		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 header-y += a.out.h
 endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
+ifneq ($(KBUILD_HEADERS)$(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
 		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 header-y += kvm.h
 endif
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
+ifneq ($(KBUILD_HEADERS)$(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
 header-y += kvm_para.h
 endif
-- 
1.7.3.2

