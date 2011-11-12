Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1KLXuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 18:50:44 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:35977 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1KLXun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 18:50:43 -0500
Subject: [PATCH] powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'
From: Paul Bolle <pebolle@tiscali.nl>
To: Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, Anatolij Gustschin <agust@denx.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 00:50:30 +0100
Message-ID: <1321141830.20271.22.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for the Freescale P3060 QDS got added by commit 96cc017c5b
("[...] Add support for P3060QDS board"). Its Kconfig entry selects
MPC8xxx_GPIO. But at the time that driver got added MPC8xxx_GPIO was
already renamed to GPIO_MPC8XXX, by commit c68308dd50c ("gpio: move
mpc8xxx/512x gpio driver to drivers/gpio").

So make this driver select GPIO_MPC8XXX.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Bravely untested: I haven't got the hardware nor the PPC toolchain
needed to build this. And it seems this needs (build) testing anyhow.

1) Sent to the people who wrote the two patches mentioned in the commit
explanation and CC'd the non-authors who signed-off these patches.

2) The config tools do not complain about selects that cannot be met
because they concern a Kconfig symbol that doesn't even exist. Shouldn't
they be made to complain in that case?

 arch/powerpc/platforms/85xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index 45023e2..d7946be 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -203,7 +203,7 @@ config P3060_QDS
 	select PPC_E500MC
 	select PHYS_64BIT
 	select SWIOTLB
-	select MPC8xxx_GPIO
+	select GPIO_MPC8XXX
 	select HAS_RAPIDIO
 	select PPC_EPAPR_HV_PIC
 	help
-- 
1.7.4.4



