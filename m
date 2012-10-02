Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2JBQha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:37:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2JBQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 15/17] ARM: rpc: check device_register return code in ecard_probe
Date: Tue,  2 Oct 2012 18:36:54 +0200
Message-Id: <1349195816-2225-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HnPDrAtnPPHPL5w5XaI4eUxRl10fzGzmEL6ILiX/j0V
 3jxuV05J9cm8rFL8cwCiWGfGSzuZt9J0NUPQPPGzHhJ+D4rSSN
 vbGzapRFx9U1WPuPOJJhHjb4lbSspeeBTLlP21INJUwMNEDUnF
 qkLp8zy/1uR/pBon9JKoCAF4vbnfcbcWzMyO2EgGuvfSESBWeU
 wlaTVUq291UTChoL3bLBSOUgUP+9CJuUUbWeZ3oLFXX5QB6rGg
 EdzG+mRYATVA57euD925fyAGr8KC00W9UHrsWIyjKMWl4qcL6L
 0iXH/G2zrwsIZgsub02H9YJUkcctkx/bTRXqtgQrxnKuxR0Xw/
 owM+nwoVnF3bHb/Yr/Z1dT3xeTDS6X+pt4bORLfwX7/H8sMJN+
 JiQMRJCAmqQyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_register is marked __must_check, so we better propagate the error
value by returning it from ecard_probe.

Without this patch, building rpc_defconfig results in:

arch/arm/mach-rpc/ecard.c: In function 'ecard_probe':
arch/arm/mach-rpc/ecard.c:963:17: warning: ignoring return value of 'device_register', declared with attribute warn_unused_result [-Wunused-result]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-rpc/ecard.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-rpc/ecard.c b/arch/arm/mach-rpc/ecard.c
index b91bc87..fcb1d59 100644
--- a/arch/arm/mach-rpc/ecard.c
+++ b/arch/arm/mach-rpc/ecard.c
@@ -960,7 +960,9 @@ static int __init ecard_probe(int slot, unsigned irq, card_type_t type)
 	*ecp = ec;
 	slot_to_expcard[slot] = ec;
 
-	device_register(&ec->dev);
+	rc = device_register(&ec->dev);
+	if (rc)
+		goto nodev;
 
 	return 0;
 
-- 
1.7.10

