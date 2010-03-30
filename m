Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0C3BuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 21:50:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64046 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0C3BuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 21:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u/CLOtKDZgjHaRrVJ8vctXHXgZ3GsNxYj05Mg0wjfQH+3NQJohcuw58r+JT8XBzqOz
         vyrvBs53NRTiW+RB0sYl51wm8gyqVpeLGO64u69PqeETrGim/MKERL9jb4ytOFz03EzI
         ij75FifqPnpFRq79521V2V9p0haSBMRhBeV0U=
From: Matt Turner <mattst88@gmail.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, ang@brigante.org,
       Matt Turner <mattst88@gmail.com>
Subject: [RFC] alpha: hack objstrip.c to make it compile.
Date: Mon, 29 Mar 2010 21:49:55 -0400
Message-Id: <1269913795-1852-1-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is the appropriate fix. What should I do to fix this?
---
 arch/alpha/boot/tools/objstrip.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
index 367d53d..54fa1ef 100644
--- a/arch/alpha/boot/tools/objstrip.c
+++ b/arch/alpha/boot/tools/objstrip.c
@@ -27,6 +27,9 @@
 #include <linux/param.h>
 #ifdef __ELF__
 # include <linux/elf.h>
+# define elfhdr	elf64_hdr
+# define elf_phdr	elf64_phdr
+# define elf_check_arch(x) ((x)->e_machine == EM_ALPHA)
 #endif
 
 /* bootfile size must be multiple of BLOCK_SIZE: */
-- 
1.6.4.4

