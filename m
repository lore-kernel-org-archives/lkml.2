Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1BZRyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:54:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44876 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1BZRyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cJxcQJ3isZKGbc1KNlgVqxU9hkQzvPvkbxOQxG+qKWyuLCBSjX8c4tzWhJ7q1u/OPL
         UCIBTJSgV5XdqEIOJi/PNzItNAjJ/Pw9vO8DUKOc9tJiudJZ7W6MPNzRVUYT1iR/kMpJ
         eIlWH8wgFhk06B577FiLoXFRKSLCm8ZdXp2Iw=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86, boot: Remove memptr
Date: Sat, 26 Feb 2011 12:54:03 -0500
Message-Id: <1298742844-8256-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use unsigned long for free memory pointers for both 32-bit and 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 2d57c97..c13b5e9 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -114,14 +114,8 @@ static int debug;
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
 
-#ifdef CONFIG_X86_64
-#define memptr long
-#else
-#define memptr unsigned
-#endif
-
-static memptr free_mem_ptr;
-static memptr free_mem_end_ptr;
+static unsigned long free_mem_ptr;
+static unsigned long free_mem_end_ptr;
 
 static char *vidmem;
 static int vidport;
@@ -318,7 +312,7 @@ static void parse_elf(void *output)
 	}
 }
 
-asmlinkage void decompress_kernel(void *rmode, memptr heap,
+asmlinkage void decompress_kernel(void *rmode, unsigned long heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output)
-- 
1.7.4

