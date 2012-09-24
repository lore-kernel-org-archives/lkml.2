Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2IXLNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:13:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35316 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2IXLNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:13:35 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "tony@atomide.com >> Tony Lindgren" <tony@atomide.com>
Subject: RE: gpmc_cs_request() causes early boot hang
Thread-Topic: gpmc_cs_request() causes early boot hang
Thread-Index: AQHNmC9WQXyKDMW1okeEKCbWWvFUTZeY7CwAgAAMaQCAAF9BgA==
Date: Mon, 24 Sep 2012 11:13:14 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93E9E7881@DBDE01.ent.ti.com>
References: <505CBFAA.3080604@mimc.co.uk>
 <C8443D0743D26F4388EA172BF4E2A7A93E9E7628@DBDE01.ent.ti.com>
 <50603B3C.8070402@mimc.co.uk>
In-Reply-To: <50603B3C.8070402@mimc.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8OBDfvK019860

Hi Mark,

On Mon, Sep 24, 2012 at 16:21:40, Mark Jackson wrote:
> On 24/09/12 05:51, Mohammed, Afzal wrote:

> > It seems you are using PSP Kernel.
> > 
> > Invoking omap_init_gpmc before gpmc request should help.
> 
> Okay ... I'm now using earlyprintk and omap_init_gpmc(), but I still get boot hangs.

> Surely omap-gpmc needs to be setup before any calls such as gpmc_cs_request() ?
> 
> Is there a method to delay my test code, or maybe get the omap-gpmc registered earlier ?

Hope below patch helps you (untested)

Regards
Afzal

----8<-------------------

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 1c53c05..a4c6912 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -827,7 +827,19 @@ static struct platform_driver gpmc_driver = {
        },
 };
 
-module_platform_driver(gpmc_driver);
+static __init int gpmc_init(void)
+{
+        return platform_driver_register(&gpmc_driver);
+}
+
+static __exit void gpmc_exit(void)
+{
+        platform_driver_unregister(&gpmc_driver);
+
+}
+
+postcore_initcall(gpmc_init);
+module_exit(gpmc_exit);
 
 int gpmc_suspend(void)
 {
----8<----------------

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
