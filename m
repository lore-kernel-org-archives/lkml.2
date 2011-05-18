Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1ERVZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:27 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44399 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1ERVZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YrRXstibcaIzUktPoJClUBfYOifbYaBHTR8lq0JeE2ntWTTE28U4F4azMPaaa6mtaj
         RNfSo5pdycNAQ23Iml+wSDN0KX/E40lzOhs+ZpY+gXWIyjWsz3NDdSJ9VQa7wpf+R+4x
         /7xtGxd8QbX2FMQsaBoP54AO6xmG957Pfr/2c=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
Date: Wed, 18 May 2011 16:24:53 -0500
Message-Id: <1305753895-24845-5-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For BGP, it is convenient for 'kmalloc' to come back with 32-byte
aligned units for torus DMA

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/page_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/page_32.h b/arch/powerpc/include/asm/page_32.h
index 68d73b2..fb0a7ae 100644
--- a/arch/powerpc/include/asm/page_32.h
+++ b/arch/powerpc/include/asm/page_32.h
@@ -9,7 +9,7 @@
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
-#ifdef CONFIG_NOT_COHERENT_CACHE
+#if defined(CONFIG_NOT_COHERENT_CACHE) || defined(CONFIG_BGP)
 #define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
 #endif
 
-- 
1.7.4.1

