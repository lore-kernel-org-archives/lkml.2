Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1EZCRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:17:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51243 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1EZCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:17:39 -0400
Date: Wed, 25 May 2011 19:17:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>
Subject: [PATCH] staging: fix olpc_dcon build, needs BACKLIGHT_CLASS_DEVICE
Message-Id: <20110525191706.a6b0f357.randy.dunlap@oracle.com>
In-Reply-To: <20110525135844.2a25f858.sfr@canb.auug.org.au>
References: <20110525135844.2a25f858.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DDDB82E.0113:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix olpc_dcon.c build by selecting the needed kconfig symbol
BACKLIGHT_CLASS_DEVICE.

olpc_dcon.c:(.text+0x11588b): undefined reference to `backlight_device_register'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Chris Ball <cjb@laptop.org>
Cc: Jon Nettleton <jon.nettleton@gmail.com>
---
 drivers/staging/olpc_dcon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110525.orig/drivers/staging/olpc_dcon/Kconfig
+++ linux-next-20110525/drivers/staging/olpc_dcon/Kconfig
@@ -2,6 +2,7 @@ config FB_OLPC_DCON
 	tristate "One Laptop Per Child Display CONtroller support"
 	depends on OLPC && FB
 	select I2C
+	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  Add support for the OLPC XO DCON controller.  This controller is
 	  only available on OLPC platforms.   Unless you have one of these
