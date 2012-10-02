Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2JBQjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:39:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2JBQhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Lennert Buytenhek <kernel@wantstofly.org>, Dan Williams <djbw@fb.com>
Subject: [PATCH 13/17] ARM: iop13xx: fix iq81340sc_atux_map_irq prototype
Date: Tue,  2 Oct 2012 18:36:52 +0200
Message-Id: <1349195816-2225-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8l57syi4mBhTY8W6NxJiH83q8fLwJqRp+VaLsuKPKNc
 vd7luGcJ0qeCO5hN4JHoRKqG18r+NYhyQXogNRqq/jxYWiM1JJ
 6b22CbZYqJlaM0WaoNJW61xdMNKa9wQbl7aOi0eyMZBrecPGOO
 wi1EGvWqnkeDBIjBYMyvnTxAubkGXxRIGfOnPRK6pvMtm3Ml5u
 JB6wr2kQfJIRKLDIxobFObVjbbmytNJ8MvRtsnCBoVZtuuzM0P
 +kyX4GXhRDOJECglbLsy9GXB9f59hhav5iDcOMrZCR8X/SHZoU
 7rS0lFQTZzRsklRiPKA2ddAI+kzqzJUqN4jtkU3bZyLP4V/BYw
 /BwtEYjlCwQ+FDDtJjxXAK4rV6QLbRQYD0hRZ0XDHUr0B2dOZw
 8bY8SoKnC9ASw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci map_irq callbacks get a 'const' pci_dev argument, so change the
iop13xx version to use the same prototype as everything else.

Without this patch, building iop13xx_defconfig results in:

arch/arm/mach-iop13xx/iq81340sc.c:63:2: warning: initialization from incompatible pointer type [enabled by default]
arch/arm/mach-iop13xx/iq81340sc.c:63:2: warning: (near initialization for 'iq81340sc_pci.map_irq') [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Dan Williams <djbw@fb.com>
---
 arch/arm/mach-iop13xx/iq81340sc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-iop13xx/iq81340sc.c b/arch/arm/mach-iop13xx/iq81340sc.c
index 060cddd..e947441 100644
--- a/arch/arm/mach-iop13xx/iq81340sc.c
+++ b/arch/arm/mach-iop13xx/iq81340sc.c
@@ -30,7 +30,7 @@
 extern int init_atu;
 
 static int __init
-iq81340sc_atux_map_irq(struct pci_dev *dev, u8 idsel, u8 pin)
+iq81340sc_atux_map_irq(const struct pci_dev *dev, u8 idsel, u8 pin)
 {
 	WARN_ON(idsel < 1 || idsel > 2);
 
-- 
1.7.10

