Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344Ab2IEUTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:19:18 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34707 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754851Ab2IEUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:19:16 -0400
Message-ID: <5047B3AD.4080307@xenotime.net>
Date: Wed, 05 Sep 2012 13:18:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH -next] extcon: extcon-arizona depends on INPUT
References: <20120824172820.ee0f412d2944b08789414207@canb.auug.org.au> <5037B41C.6040703@xenotime.net> <503AB70E.2000407@samsung.com> <504693E4.8050808@xenotime.net> <20120905032802.GB5076@opensource.wolfsonmicro.com> <20120905191657.GA5842@kroah.com>
In-Reply-To: <20120905191657.GA5842@kroah.com>
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
