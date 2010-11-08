Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0KHOeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:34:17 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54054
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754549Ab0KHOeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:34:16 -0500
X-SpamScore: -35
X-BigFish: VPS-35(zz542N1418M1432N98dN4015L9371Pzz1202hzz8275dhz2dh95h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: RE: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
Date: Mon, 8 Nov 2010 07:34:05 -0700
In-Reply-To: <4CD7FB27.9030804@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
Thread-Index: Act/SPKZlMepD54hSiqUU51rQ8cdngACNC/w
References: <20101014161724.18966.42340.stgit@localhost6.localdomain6> <4CD7FB27.9030804@monstr.eu>
From: John Linn <John.Linn@xilinx.com>
To: <monstr@monstr.eu>, <grant.likely@secretlab.ca>
CC: <spi-devel-general@lists.sourceforge.net>,
        <richard.rojfors@mocean-labs.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Nov 2010 14:34:06.0003 (UTC) FILETIME=[FF273830:01CB7F51]
X-RCIS-Action: ALLOW
Message-ID: <ec622bb7-57d1-4aa2-80f1-65fa4b3fa7eb@VA3EHSMHS033.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA8EYY91016814

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Monday, November 08, 2010 6:29 AM
> To: grant.likely@secretlab.ca
> Cc: spi-devel-general@lists.sourceforge.net; richard.rojfors@mocean-labs.com; John Linn; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 0/3] spi/xilinx: Merge OF and non-OF drivers
> 
> Hi Grant,
> 
> Grant Likely wrote:
> > Since of_platform_bus_type has been merged with the platform_bus_type,
> > a single platform driver can now support both use cases.  This patch
> > series merges the two halves of the xilinx_spi device driver.
> >
> > Compile tested only.  I haven't booted this yet.
> 
> I have tested it on sp605 and works well. Have you added that patches
> to your repository? Or are they somewhere else? Who is responsible for?
> 
> I would like to also discuss one change which is related mmc_spi kernel driver.
> Let me describe the problem. Microblaze can use dma in all addresses
> that's why dma_mask is setup to 0xffffffff in of_platform_device_create.
> Xilinx spi driver doesn't support dma but mmc_spi driver is checking dma_mask in parent device
> which is xilinx spi driver.
> 
> Here is the corresponding the part of code (Expect dma_mask=zero for no dma operations).
> mmc_spi.c:~1395
> 	if (spi->master->dev.parent->dma_mask) {
> 		struct device	*dev = spi->master->dev.parent;
> 
> 		host->dma_dev = dev;
> 
> 
> Based on this one our customer came with the following solution to setup
> dma_mask in xilinx_spi to zero and then mmc_spi doesn't setup dma operation.
> 
> I think that this is nice solution but I would like to be sure that I didn't miss anything.
> After that i will create proper patch with description.

Seems reasonable to me.

Thanks,
John

> 
> 
> diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
> index 7adaef6..3612e1b 100644
> --- a/drivers/spi/xilinx_spi.c
> +++ b/drivers/spi/xilinx_spi.c
> @@ -519,6 +519,9 @@ static int __devinit xilinx_spi_probe(struct platform_device *dev)
>         }
> 
>         platform_set_drvdata(dev, master);
> +       /* clear the dma_mask, to try to disable use of dma */
> +       dev->dev.dma_mask = 0;
> +
>         return 0;
>  }
> 
> 
> Thanks,
> Michal
> 
> 
> --
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
