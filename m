Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2BQDZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:25:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41791 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2BQDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:25:28 -0500
Message-ID: <1329449121.17110.2.camel@phoenix>
Subject: [PATCH 2/2] ARM: imx/pcm038: Don't specify regulator consumers by
 struct device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 17 Feb 2012 11:25:21 +0800
In-Reply-To: <1329449029.17110.1.camel@phoenix>
References: <1329449029.17110.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev field is remove from struct regulator_consumer_supply since commit
737f36 "regulator: Remove support for supplies specified by struct device".

This fixes below build error:
  CC      arch/arm/mach-imx/mach-pcm038.o
arch/arm/mach-imx/mach-pcm038.c:236: error: unknown field 'dev' specified in initializer
make[1]: *** [arch/arm/mach-imx/mach-pcm038.o] Error 1
make: *** [arch/arm/mach-imx] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next 20120217.

 arch/arm/mach-imx/mach-pcm038.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-imx/mach-pcm038.c b/arch/arm/mach-imx/mach-pcm038.c
index 16f126d..bfcc1ea 100644
--- a/arch/arm/mach-imx/mach-pcm038.c
+++ b/arch/arm/mach-imx/mach-pcm038.c
@@ -233,7 +233,6 @@ static struct regulator_init_data sdhc1_data = {
 
 static struct regulator_consumer_supply cam_consumers[] = {
 	{
-		.dev	= NULL,
 		.supply	= "imx_cam_vcc",
 	},
 };
-- 
1.7.5.4



