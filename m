Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037Ab2INVi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:38:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab2INVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 24/24] net: seeq: use __iomem pointers for MMIO
Date: Fri, 14 Sep 2012 23:34:52 +0200
Message-Id: <1347658492-11608-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347658492-11608-1-git-send-email-arnd@arndb.de>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uNjnTbOT07cXZxX6nPHrQLKBrrIN00r0VzDHjutRG+J
 PM6xtCNhA8B3dxFenSLUZlT49mn1Zb42HD7e+FMUFzaXvVIOm/
 lzUTOlS47rSQKTUbu8CeA/vRLlRw/xrv9PWPwMzgM/2y7uoJLb
 75B5/iOH+sXGznT2BPUiS7QmDYiTs7nhWkdG4H/EGeosDOE8pn
 J0HEdkWXi7JuQ6tu0syGz4Kf8qV3n6ogJU9jvZE/XZ7Cvn04ph
 Ka8D94syRb0u1E9B++/j39eJMDiZPzQCyW5vG5foN9U7ihErwh
 Ryg/wpHNnjNV8s8tFauCxKyHMCYTvrS9cP0CujT4quNuxoEWR6
 b0eA8TyyU3nH7NdqIguXk1pEcPVuiyqACA+YhZGVBI18wmDnjT
 MNdAu/PaeU2EA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM is moving to stricter checks on readl/write functions,
so we need to use the correct types everywhere.

Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/seeq/ether3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index df808ac..6a40dd0 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -99,13 +99,13 @@ typedef enum {
  * The SEEQ8005 doesn't like us writing to its registers
  * too quickly.
  */
-static inline void ether3_outb(int v, const void __iomem *r)
+static inline void ether3_outb(int v, void __iomem *r)
 {
 	writeb(v, r);
 	udelay(1);
 }
 
-static inline void ether3_outw(int v, const void __iomem *r)
+static inline void ether3_outw(int v, void __iomem *r)
 {
 	writew(v, r);
 	udelay(1);
-- 
1.7.10

