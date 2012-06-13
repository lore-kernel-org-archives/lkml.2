Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab2FMSmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:42:11 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6409 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2FMSlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:41:50 -0400
Message-ID: <1339612907.13326.5.camel@lorien2>
Subject: [PATCH] x86: kernel/cpu/mtrr/cleanup.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com
Cc: shuahkhan@gmail.com, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jun 2012 12:41:47 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change parse_mtrr_spare_reg() to call kstrtoul() instead of calling obsoleted
simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ac140c7..601aa4e 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -465,7 +465,7 @@ static unsigned long nr_mtrr_spare_reg __initdata =
 static int __init parse_mtrr_spare_reg(char *arg)
 {
 	if (arg)
-		nr_mtrr_spare_reg = simple_strtoul(arg, NULL, 0);
+		kstrtoul(arg, 0, &nr_mtrr_spare_reg);
 	return 0;
 }
 early_param("mtrr_spare_reg_nr", parse_mtrr_spare_reg);
-- 
1.7.9.5



