Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979Ab2HHV20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:28:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab2HHV2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 07/10] ARM: rpc: check device_register return code in ecard_probe
Date: Wed,  8 Aug 2012 23:27:55 +0200
Message-Id: <1344461278-28245-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:E9fjT7aUzpuo9qEZjxj6x6irjR8/HAzod7dp9OIVp4H
 llmGJxbTQaXjRrBiwU8Y+nH6QAroUGOiRYhgETi6zGifW/M7WE
 8JKWYJ3iqsuTxHBbe2YIj40k6m5/MIIkWLjrcz6qeaFnbOR9Ft
 cwCQ2sVvBIXnSHJmZqD3bkNruRtaktH0Bq5EVwl4N45HPfu64H
 okfz+1pEcybHDvhK/72yQGZgApRUdgxvtIm9+Uuv91zogwU8p7
 clQo4HU6Um5wDP4EjdgJMsYpaiwTQ4fAnHAfCcLIqGwcbzOBN8
 A93+mfArEO4sOv9v4/sgCKrXe6g/+Ym1YBQwteZksBN3gv0xL6
 5jvpjNJUxZHq+gwcGuSNMrNW2CCXoceAj2oQPjtA5gf2JPOl6P
 0VjTUPHcBI10A==
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

