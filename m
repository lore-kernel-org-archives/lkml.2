Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab0GQNDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 09:03:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52139 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0GQNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 09:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xxyKBro9fl4257gXj8su+zo+P5Rl1dDE8R7KnoGHqS2ue/GzVwxGVbX/xYnOpRtx/z
         tTVu9HkaXWvV22p6NXbpSmtjNEeBgSCMzJceQgsBzW37KYSajJ1j4Ze1rE4Dr5wOF0Ej
         ZQlcsRc23wqZXew/Rfrjv7yYW7uB+1nzcOOM0=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86-64: Simplify loading initial_gs
Date: Sat, 17 Jul 2010 09:03:28 -0400
Message-Id: <1279371808-24804-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Load initial_gs as two 32-bit values instead of splitting a 64-bit value.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/head_64.S |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3d1e6f1..239046b 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -234,9 +234,8 @@ ENTRY(secondary_startup_64)
 	 * init data section till per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	initial_gs(%rip),%rax
-	movq    %rax,%rdx
-	shrq	$32,%rdx
+	movl	initial_gs(%rip),%eax
+	movl	initial_gs+4(%rip),%edx
 	wrmsr	
 
 	/* esi is pointer to real mode structure with interesting info.
-- 
1.7.1.1

