Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759709Ab2HXREl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:04:41 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33500 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757234Ab2HXREi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:04:38 -0400
Message-ID: <5037B41C.6040703@xenotime.net>
Date: Fri, 24 Aug 2012 10:04:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] extcon: extcon-arizona depends on INPUT
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
In-Reply-To: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

extcon-arizona uses input_*() functions so it should depend
on INPUT.

ERROR: "input_event" [drivers/extcon/extcon-arizona.ko] undefined!
ERROR: "input_free_device" [drivers/extcon/extcon-arizona.ko] undefined!
ERROR: "input_register_device" [drivers/extcon/extcon-arizona.ko] undefined!
ERROR: "input_set_capability" [drivers/extcon/extcon-arizona.ko] undefined!
ERROR: "input_allocate_device" [drivers/extcon/extcon-arizona.ko] undefined!
ERROR: "input_unregister_device" [drivers/extcon/extcon-arizona.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120824.orig/drivers/extcon/Kconfig
+++ linux-next-20120824/drivers/extcon/Kconfig
@@ -41,7 +41,7 @@ config EXTCON_MAX8997
 
 config EXTCON_ARIZONA
 	tristate "Wolfson Arizona EXTCON support"
-	depends on MFD_ARIZONA
+	depends on MFD_ARIZONA && INPUT
 	help
 	  Say Y here to enable support for external accessory detection
 	  with Wolfson Arizona devices. These are audio CODECs with
