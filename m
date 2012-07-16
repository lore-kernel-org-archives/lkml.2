Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2GPPdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:33:00 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58409 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751916Ab2GPPcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:32:54 -0400
Message-ID: <500433F3.8030104@xenotime.net>
Date: Mon, 16 Jul 2012 08:32:03 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging: fix sm7xxfb build, depends on PCI
References: <20120716171709.a2da2c69fd0052b1a519de65@canb.auug.org.au>
In-Reply-To: <20120716171709.a2da2c69fd0052b1a519de65@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

sm7xxfb.c is a PCI driver, so make it depend on PCI.
Fixes these build warnings:

drivers/staging/sm7xxfb/sm7xxfb.c:1063:1: warning: data definition has no type or storage class
drivers/staging/sm7xxfb/sm7xxfb.c:1063:1: warning: type defaults to 'int' in declaration of 'module_pci_driver'
drivers/staging/sm7xxfb/sm7xxfb.c:1063:1: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
---
 drivers/staging/sm7xxfb/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120716.orig/drivers/staging/sm7xxfb/Kconfig
+++ linux-next-20120716/drivers/staging/sm7xxfb/Kconfig
@@ -1,6 +1,6 @@
 config FB_SM7XX
 	tristate "Silicon Motion SM7XX framebuffer support"
-	depends on FB
+	depends on FB && PCI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
