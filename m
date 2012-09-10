Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2IJDZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:25:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42326 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2IJDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:25:17 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 12:25:15 +0900
Message-ID: <CAOAMb1CTk1_dQAUiHy5ch=UxN7vSe0of81KcKbjPjCFqR9e9tw@mail.gmail.com>
Subject: [PATCH] ARM: Fix build warning in do_alignment.
From: Chanho Min <chanho0207@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Stephen Warren <swarren@nvidia.com>,
        David Howells <dhowells@redhat.com>, Nicolas Pitre <nico@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning:

arch/arm/mm/alignment.c: In function 'do_alignment':
arch/arm/mm/alignment.c:327:15: warning: 'offset.un' may be used
uninitialized in this function [-Wuninitialized]
arch/arm/mm/alignment.c:749:21: note: 'offset.un' was declared here

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 arch/arm/mm/alignment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 9107231..f83b38c 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -746,7 +746,7 @@ do_alignment_t32_to_handler(unsigned long *pinstr,
struct pt_regs *regs,
 static int
 do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 {
-	union offset_union offset;
+	union offset_union offset = {0};
 	unsigned long instr = 0, instrptr;
 	int (*handler)(unsigned long addr, unsigned long instr, struct pt_regs *regs);
 	unsigned int type;
-- 
1.7.9.5
