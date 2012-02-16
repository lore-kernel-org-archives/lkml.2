Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2BPOyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:54:51 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:42799 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab2BPOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:54:49 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, tony@atomide.com,
        s.hauer@pengutronix.de, magnus.damm@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 1/2] ARM: remove memmove from boot/compressed/string.c
Date: Thu, 16 Feb 2012 15:54:16 +0100
Message-Id: <1329404057-26346-2-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1329404057-26346-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the memmove function from boot/compressed/string.c
- This definition conflicts with the one in lib/decompress_unxz.c
  This change is required to support xz compression on ARM.
- memmove is not used in any of the other decompressors
  in lib/decompress_*.c

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/boot/compressed/string.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
index 36e53ef..369443a 100644
--- a/arch/arm/boot/compressed/string.c
+++ b/arch/arm/boot/compressed/string.c
@@ -40,6 +40,7 @@ void *memcpy(void *__dest, __const void *__src, size_t __n)
 	return __dest;
 }
 
+/*
 void *memmove(void *__dest, __const void *__src, size_t count)
 {
 	unsigned char *d = __dest;
@@ -55,6 +56,7 @@ void *memmove(void *__dest, __const void *__src, size_t count)
 		d[count] = s[count];
 	return __dest;
 }
+*/
 
 size_t strlen(const char *s)
 {
-- 
1.7.4.1

