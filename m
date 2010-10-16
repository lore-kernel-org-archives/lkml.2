Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab0JPE0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:26:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0JPE0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:message-id:from:date;
        b=FN5KN1XxbxkJuvmL7eZOlPImDNLfM2O5q/Cy7yaTp9Sx7WS2yzhJ7Nu+zqjTQQS100
         p+MrIUtLnBJOzLxudvwBG0XECq8QXZBXAWAelQlmWb6uwCgBLS2lYPGU9vWMJC9a4xmf
         Inu4dQUSKSs59ywK1Xn75wW0Cscjx91TUb/sc=
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, viro@ftp.linux.org.uk
Subject: [MIPS] Fix compile failure in 2.6.36-rc8 on 32-bit MIPS
Message-Id: <E1P6yLw-0007i6-SH@localhost>
From: Shane McDonald <mcdonald.shane@gmail.com>
Date: Fri, 15 Oct 2010 22:26:40 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a typo in commit d27240b, MIPS: Sanitize restart logics,
that causes a compile failure in 2.6.36-rc8 on 32-bit MIPS systems.
This patch corrects that typo.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/kernel/scall32-o32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/scall32-o32.S b/arch/mips/kernel/scall32-o32.S
index 58fb2bc..fbaabad 100644
--- a/arch/mips/kernel/scall32-o32.S
+++ b/arch/mips/kernel/scall32-o32.S
@@ -63,7 +63,7 @@ stack_done:
 	sw	t0, PT_R7(sp)		# set error flag
 	beqz	t0, 1f
 
-	lw	t1, PR_R2(sp)		# syscall number
+	lw	t1, PT_R2(sp)		# syscall number
 	negu	v0			# error
 	sw	t1, PT_R0(sp)		# save it for syscall restarting
 1:	sw	v0, PT_R2(sp)		# result
-- 
1.6.2.4

