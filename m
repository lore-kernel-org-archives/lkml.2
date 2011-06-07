Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1FGS1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:27:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:22879 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1FGS1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:27:44 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1307471261!25054232!16
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jun 2011 13:27:32 -0500
Subject: RE: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
Thread-Topic: [PATCH] treewide: Convert uses of struct resource * to
 resource_size(ptr)
Thread-Index: AcwkruaoVkwNIxP2QoSFuSpqo2cYswAgtvSw
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B7EB4@AUSP01VMBX24.collaborationhost.net>
References: <201106061349.00474.hartleys@visionengravers.com>
	 <1307397174.4994.26.camel@Joe-Laptop>
	 <ADE657CA350FB648AAC2C43247A983F001F3820B7C78@AUSP01VMBX24.collaborationhost.net>
 <1307408678.4994.46.camel@Joe-Laptop>
In-Reply-To: <1307408678.4994.46.camel@Joe-Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p57IRoAS015170

On Monday, June 06, 2011 6:05 PM, Joe Perches wrote:
> Done via coccinelle script:
> 
> struct resource *ptr;
> @@
> 
> - ptr->end - ptr->start + 1
> + resource_size(ptr)
> 
> Mostly uncompiled, not enough cross-compilers.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
>> I think most of the offenders were caught back in late 2009.
> 
> There are quite a few left...

FWIW, your patch missed a couple...


>  arch/arm/plat-s5p/sysmmu.c                 |    2 +-

	((res->end) - (res->start)) + 1

arch/arm/plat-samsung/pm-check.c

	(u32)(res->end - res->start)+1

arch/mips/pci/ops-tx3927.c

	channel->io_resource->end - channel->io_resource->start;
	channel->mem_resource->end - channel->mem_resource->start;

These two look like they are missing the + 1.

> arch/powerpc/sysdev/ppc4xx_pci.c           |    6 +++---

	res->end + 1 - res->start

drivers/acpi/apei/apei-base.c

	res->end - res->start

There are a couple of these, they look like they are missing the + 1.

drivers/gpio/gpio-u300.c

	memres->end - memres->start

Missing + 1.

drivers/message/i2o/iop.c

	1 + res->end - res->start

drivers/mtd/maps/ixp2000.c

	dev->resource->end - dev->resource->start + 1

drivers/mtd/maps/sa1100-flash.c

	phys = res->start;
	size = res->end - phys + 1;

drivers/rtc/rtc-cmos.c

	ports->end + 1 - ports->start

drivers/rtc/rtc-mrst.c

	iomem->end + 1 - iomem->start

drivers/video/mb862xx/mb862xxfbdrv.c

	1 + par->res->end - par->res->start

drivers/video/mbx/mbxfb.c

	#define res_size(_r) (((_r)->end - (_r)->start) + 1)

drivers/video/msm/mdp.c

	resource->end - resource->start

Missing + 1.

drivers/video/msm/msm_fb.c

	resource->end - resource->start

Missing + 1.


There are also a number that look like:

	res.end - res.start + 1
and
	res.end + 1 - res.start


Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
