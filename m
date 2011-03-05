Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab1CEBfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:35:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20332 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab1CEBft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:35:49 -0500
Date: Fri, 4 Mar 2011 17:33:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH -next] soc: sgtl5000 uses regulator interfaces
Message-Id: <20110304173357.23d36116.randy.dunlap@oracle.com>
In-Reply-To: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D719367.0023,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

sgtl5000 uses regulator interfaces, so make selecting it depend
on REGULATOR.

sgtl5000.c:(.text+0x4ae33): undefined reference to `regulator_unregister'
sgtl5000.c:(.text+0x4af41): undefined reference to `rdev_get_drvdata'
sgtl5000.c:(.text+0x4b191): undefined reference to `regulator_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zeng Zhaoming <zhaoming.zeng@freescale.com>
---
 sound/soc/codecs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110304.orig/sound/soc/codecs/Kconfig
+++ linux-next-20110304/sound/soc/codecs/Kconfig
@@ -33,7 +33,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_MAX98088 if I2C
 	select SND_SOC_MAX9877 if I2C
 	select SND_SOC_PCM3008
-	select SND_SOC_SGTL5000 if I2C
+	select SND_SOC_SGTL5000 if I2C && REGULATOR
 	select SND_SOC_SN95031 if INTEL_SCU_IPC
 	select SND_SOC_SPDIF
 	select SND_SOC_SSM2602 if I2C
