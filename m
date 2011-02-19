Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1BSB22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 20:28:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20352 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab1BSB20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 20:28:26 -0500
Date: Fri, 18 Feb 2011 17:25:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Luciano Coelho <luciano.coelho@nokia.com>,
        Roger Quadros <roger.quadros@nokia.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] wl12xx: fix sdio_test kconfig/build errors
Message-Id: <20110218172536.970b5b39.randy.dunlap@oracle.com>
In-Reply-To: <20110217162650.092e77c3.sfr@canb.auug.org.au>
References: <20110217162650.092e77c3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D5F1C87.00C1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The wl12xx sdio_test code uses wl12xx_get_platform_data, which is
only present when WL12*_SDIO is enabled, so make WL12XX_SDIO_TEST
depend on WL12XX_SDIO so that the needed interface will be present.

sdio_test.c:(.devinit.text+0x13178): undefined reference to `wl12xx_get_platform_data'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110217.orig/drivers/net/wireless/wl12xx/Kconfig
+++ linux-next-20110217/drivers/net/wireless/wl12xx/Kconfig
@@ -54,7 +54,7 @@ config WL12XX_SDIO
 
 config WL12XX_SDIO_TEST
 	tristate "TI wl12xx SDIO testing support"
-	depends on WL12XX && MMC
+	depends on WL12XX && MMC && WL12XX_SDIO
 	default n
 	---help---
 	  This module adds support for the SDIO bus testing with the
