Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2DKSIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 14:08:53 -0400
Received: from mail.meprolight.com ([194.90.149.17]:29833 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932832Ab2DKSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 14:08:51 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <g.liakhovetski@gmx.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH] ARM: i.mx35 increase dma consistent region size
Date: Wed, 11 Apr 2012 21:01:14 +0300
Message-ID: <1334167274-29524-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default size of the consistent DMA region is 2MB
without this patch, attempt to allocate more than 2MB
is causing allocation failure

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 arch/arm/mach-imx/mm-imx3.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
index 7412738..a2c0c7d 100644
--- a/arch/arm/mach-imx/mm-imx3.c
+++ b/arch/arm/mach-imx/mm-imx3.c
@@ -201,6 +201,7 @@ static struct map_desc mx35_io_desc[] __initdata = {
 void __init mx35_map_io(void)
 {
 	iotable_init(mx35_io_desc, ARRAY_SIZE(mx35_io_desc));
+	init_consistent_dma_size(SZ_8M);
 }
 
 void __init imx35_init_early(void)
-- 
1.7.0.4

