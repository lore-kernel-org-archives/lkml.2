Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0GNV1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:27:12 -0400
Received: from mail.perches.com ([173.55.12.10]:1886 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757420Ab0GNV1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:27:11 -0400
Subject: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 14:27:08 -0700
Message-ID: <1279142828.5816.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the only "," terminated statements that
precede a pr_<level> in the kernel tree.

These must be ";" terminated if the pr_<level>
macros becomes a bit more space efficient using
a "do { foo } while (0)" form.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 06130b5..c5f59d0 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -632,9 +632,9 @@ static void __init mtrr_print_out_one_result(int i)
 	unsigned long gran_base, chunk_base, lose_base;
 	char gran_factor, chunk_factor, lose_factor;
 
-	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
-	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
-	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
+	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor);
+	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor);
+	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor);
 
 	pr_info("%sgran_size: %ld%c \tchunk_size: %ld%c \t",
 		result[i].bad ? "*BAD*" : " ",



