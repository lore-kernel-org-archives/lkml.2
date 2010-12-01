Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0LAQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:28:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48818 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0LAQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wXFJOg0dS24S3ZAZCgGNKY7lWDd+UlJbuKh4rTvMFyHH1krQto6OuaWFKqPVuDolal
         ZDs//j5Q1RjMFJr9wuc0lBh/jPfqkpMccUb+q60VXPZIuCEubVBMnsSPNW+K7Yr/qXdp
         WX+4RoiOe/A2OuIKPrUNQiz5rhYUo09EejaQI=
Subject: [PATCH] ifdef gic_present variable that is used only by malta
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 22:01:15 +0530
Message-ID: <1291221075.31413.24.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gic_present variable will be used only in malta platforms.Other
platforms with VSMP support will throw link error.
 

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/kernel/smp-mt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 43e7cdc..5b91c1a 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -151,6 +151,7 @@ static void vsmp_send_ipi_mask(const struct cpumask
*mask, unsigned int action)
 
 static void __cpuinit vsmp_init_secondary(void)
 {
+#ifdef CONFIG_MIPS_MALTA
 	extern int gic_present;
 
 	/* This is Malta specific: IPI,performance and timer inetrrupts */
@@ -158,6 +159,7 @@ static void __cpuinit vsmp_init_secondary(void)
 		change_c0_status(ST0_IM, STATUSF_IP3 | STATUSF_IP4 |
 					 STATUSF_IP6 | STATUSF_IP7);
 	else
+#endif /* CONFIG_MIPS_MALTA */
 		change_c0_status(ST0_IM, STATUSF_IP0 | STATUSF_IP1 |
 					 STATUSF_IP6 | STATUSF_IP7);
 }
-- 
1.7.0.4



