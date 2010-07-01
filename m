Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0GANZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:25:18 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53822 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753626Ab0GANZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:25:17 -0400
Date: Thu, 1 Jul 2010 15:25:16 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
Message-ID: <20100701132515.GC32541@faui48a.informatik.uni-erlangen.de>
References: <cover.1277911345.git.siccegge@cs.fau.de> <e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de> <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:55:47PM +0900, Jassi Brar wrote:
> On Thu, Jul 1, 2010 at 1:03 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
> > SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
> > all references for it from the source code.
> I'd rather have the code compiled unconditionally.

OK that would be done by the patch below

----
From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 30 Jun 2010 17:18:52 +0200
Subject: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710

SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
all references for it from the source code, building the parts
unconditionally

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 arch/arm/mach-s3c2443/mach-smdk2443.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-s3c2443/mach-smdk2443.c b/arch/arm/mach-s3c2443/mach-smdk2443.c
index 4c863d3..764144a 100644
--- a/arch/arm/mach-s3c2443/mach-smdk2443.c
+++ b/arch/arm/mach-s3c2443/mach-smdk2443.c
@@ -106,9 +106,7 @@ static struct platform_device *smdk2443_devices[] __initdata = {
 	&s3c_device_wdt,
 	&s3c_device_i2c0,
 	&s3c_device_hsmmc0,
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
 	&s3c_device_ac97,
-#endif
 };
 
 static void __init smdk2443_map_io(void)
@@ -122,9 +120,7 @@ static void __init smdk2443_machine_init(void)
 {
 	s3c_i2c0_set_platdata(NULL);
 
-#ifdef CONFIG_SND_SOC_SMDK2443_WM9710
 	s3c24xx_ac97_setup_gpio(S3C24XX_AC97_GPE0);
-#endif
 
 	platform_add_devices(smdk2443_devices, ARRAY_SIZE(smdk2443_devices));
 	smdk_machine_init();
-- 
1.7.0.4

