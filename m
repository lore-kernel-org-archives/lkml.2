Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2HHV2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:28:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab2HHV2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Andrey Porodko <panda@chelcom.ru>
Subject: [PATCH 06/10] ARM: davinci: don't use broken ntosd2_init_i2c
Date: Wed,  8 Aug 2012 23:27:54 +0200
Message-Id: <1344461278-28245-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DHPFueg9/b7qP9mdSCUBD6q5epGLauS8DIZySwx+Dqs
 pUgFVHv9W14euzKZhHCF7M+bNpKnrrgWPODEjJVgDu4vmS7zH5
 wH+r1AKWDF8ad2kMb+2s8G4/b7wjQ4ANr7zlYIIbRqwn5yybLS
 u9hlHLmVvqy1LYdkBO4sGSxdDsQyhPtFDoTdd/LBk4Fkecvv+P
 ji8DU7wL06IE3zk9xb7cifpV7/8MYjLn1i4glFnNhJgtZI17ww
 nTY73BgEJzKTP/CiZs8TAWInKFTJvj8eWxN5MBYJkft5IPasDG
 +KsLY9U69rq3ReUllWSjAyl1eu4lpTOjFklLbAp4Mota9O7fnz
 lVMikcJujuaNAhYoED6JfQ56p2xSHOZQb5GRlzbsAjs20YICdV
 AOtLwhyVs4cYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ntosd2_init_i2c walks the ntosd2_i2c_info array, which it expects to
be populated with at least one member. gcc correctly warns about
the out-of-bounds access here.

Without this patch, building davinci_all_defconfig results in:

arch/arm/mach-davinci/board-neuros-osd2.c: In function 'davinci_ntosd2_init':
arch/arm/mach-davinci/board-neuros-osd2.c:187:20: warning: array subscript is above array bounds [-Warray-bounds]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Andrey Porodko <panda@chelcom.ru>
---
 arch/arm/mach-davinci/board-neuros-osd2.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 5de69f2..9d40df9 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -162,6 +162,7 @@ static void __init davinci_ntosd2_map_io(void)
 	dm644x_init();
 }
 
+#if 0
 /*
  I2C initialization
 */
@@ -193,6 +194,12 @@ static	int ntosd2_init_i2c(void)
 	}
 	return status;
 }
+#else
+static  int ntosd2_init_i2c(void)
+{
+	return 0;
+}
+#endif
 
 static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 	.wires		= 4,
-- 
1.7.10

