Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2JIPYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:24:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2JIPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4/9] ARM: export default read_current_timer
Date: Tue,  9 Oct 2012 17:22:58 +0200
Message-Id: <1349796183-30648-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tQwDLTbDKdlxamDX8PrzfRSjNrYedr3CNwVYu4j8u9v
 d00uiBeOHEZ8PJKgOCAR+Q2VhSAfsmxXAPOo9CleWzmQGQyVSq
 x9AqzTCj6R0l1/4VqdDcy8mkuw70Fkx9yzah8lJN7m0gBUHUgu
 +tp2MsUSY0Zd16OPX9nOYnVvE0iUelqostHGCnSclQCfGT1i9/
 /2pVUSd+9K5lMyaZlSCusrby8HArnNH63/nxwxfH9bn7OYzKZv
 Ulc9KV8rVJDE57EFRAPbsvlIKfAffS3cHGTrKXaJhKq1DwGpFA
 3VCB6w+/6szd+kuGg1OGHDVKyzI+c60hbyIHHpDl8DY839p5Pi
 uw3QNbcJsHtmCg1WiybxNR6ACgb1zF6hMdtehMd+BNrbMlqgWc
 pZob+kF4OxShJEnk/V7/kbxOlTJBSlgMeY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_current_timer is used by get_cycles since "ARM: 7538/1: delay:
add registration mechanism for delay timer sources", and get_cycles
can be used by device drivers in loadable modules, so it has to
be exported.

Without this patch, building imote2_defconfig fails with

ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jonathan Austin <jonathan.austin@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/lib/delay.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/lib/delay.c b/arch/arm/lib/delay.c
index 9d0a300..0dc5385 100644
--- a/arch/arm/lib/delay.c
+++ b/arch/arm/lib/delay.c
@@ -45,6 +45,7 @@ int read_current_timer(unsigned long *timer_val)
 	*timer_val = delay_timer->read_current_timer();
 	return 0;
 }
+EXPORT_SYMBOL_GPL(read_current_timer);
 
 static void __timer_delay(unsigned long cycles)
 {
-- 
1.7.10

