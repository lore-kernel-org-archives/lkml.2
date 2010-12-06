Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab0LFITd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:19:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58864 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0LFITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KGRFXhriWcgZMo890kF8En6sC6Capuh8KMFHOkYlN4x/8TET1n21vuRqhMQSVjiBx1
         mkstEL7ffxvy7dcXP/bX+FWLATBbDK/Vg+NaLG+pXF17vyOc7cEaLPxi2zqqL4iBqNFZ
         BKiXtOKt8A6ynxVcygYieZiL40XEIHizk3Scc=
Subject: [PATCH] Introduce mips_late_time_init
From: Anoop P A <anoop.pa@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 13:53:32 +0530
Message-ID: <1291623812.31822.6.camel@paanoop1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves plat_time_init and clocksoure init funtion calls to
late_time_init. 

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index fb74974..dbd1ac5 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -117,10 +117,16 @@ static __init int cpu_has_mfc0_count_bug(void)
 	return 0;
 }
 
-void __init time_init(void)
+void __init mips_late_time_init(void)
 {
 	plat_time_init();
 
 	if (!mips_clockevent_init() || !cpu_has_mfc0_count_bug())
 		init_mips_clocksource();
 }
+
+
+void __init time_init(void)
+{
+	late_time_init = mips_late_time_init;
+}


