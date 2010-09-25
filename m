Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0IYTUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 15:20:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33462 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0IYTUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 15:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=gNYiJVqk327p07VJ5NSupLG6mN0i44uEr4xX3HonEnNv/mlmCK2kbA9MyxQX30dtgD
         HFIVKAoU3jTY4ciZ5X5AQDub6F/ml2XxMixsfkrizJThm+oaGDmx2tZzwfvZNzPJMrku
         SrFX4GlS5BOGnuUELsHpWZRSmAkIUBrQ2huVA=
MIME-Version: 1.0
From: Dragos Tatulea <dragos.tatulea@gmail.com>
Date: Sat, 25 Sep 2010 21:20:01 +0200
Message-ID: <AANLkTikJ4wreMMU0y-k7MRg_ju_u2BNu66mqq2NAY-xi@mail.gmail.com>
Subject: [PATCH] Fix MIPS math-emu -Werror compile failure encountered while
 doing a Malta build.
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dragos Tatulea <dragos.tatulea@gmail.com>
---
 arch/mips/math-emu/cp1emu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 47842b7..c0af7f1 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1243,7 +1243,7 @@ int fpu_emulator_cop1Handler(struct pt_regs
*xcp, struct mips_fpu_struct *ctx,
        int has_fpu)
 {
        unsigned long oldepc, prevepc;
-       mips_instruction insn;
+       mips_instruction uninitialized_var(insn);
        int sig = 0;

        oldepc = xcp->cp0_epc;
-- 
1.7.2.3
