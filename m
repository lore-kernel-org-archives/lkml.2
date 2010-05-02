Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0EBX6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 19:58:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61687 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab0EBX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 19:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i0uMqok+hNqL3t26b7NuhjG0iCd0QHUvGA680waW6ymVPL7GzcEhvNEOQ6pK14Q1Cw
         aZkh7gs+vTDZV+YiVbgUU2dyEtuTtPBQXTXBhk930quwv16VekrjyWabi9fz6vy6p7Ml
         lDqj0s+nGPbK2z1HhqE7tn3npi8WirrbqkXnA=
From: Nicolas Thill <nicolas.thill@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nicolas Thill <nico@openwrt.org>
Subject: [PATCH] UML: x86_64: fix memcpy export
Date: Mon,  3 May 2010 01:58:20 +0200
Message-Id: <1272844700-32496-1-git-send-email-nico@openwrt.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

./arch/um/sys-x86_64/ksyms.c exports memcpy or __memcpy depending on the gcc
version, use the same logic in ./arch/um/os-Linux/user_syms.c

Signed-off-by: Nicolas Thill <nico@openwrt.org>
---
 arch/um/os-Linux/user_syms.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
index 89b48a1..e3a12dd 100644
--- a/arch/um/os-Linux/user_syms.c
+++ b/arch/um/os-Linux/user_syms.c
@@ -23,7 +23,8 @@ extern int printf(const char *, ...);
 EXPORT_SYMBOL(strstr);
 #endif
 
-#ifndef __x86_64__
+#if !defined(__x86_64) || \
+	(__GNUC__ == 4 && __GNUC_MINOR__ < 3) || (__GNUC__ < 4)
 extern void *memcpy(void *, const void *, size_t);
 EXPORT_SYMBOL(memcpy);
 #endif
-- 
1.6.0.4

