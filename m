Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2JXMZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:25:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2JXMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:25:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Date: Wed, 24 Oct 2012 12:24:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jon Masters <jcm@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <5087D574.4030503@free-electrons.com> <5087D6B8.10209@free-electrons.com>
In-Reply-To: <5087D6B8.10209@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241224.06791.arnd@arndb.de>
X-Provags-ID: V02:K0:wyTzciTTax6U8VCzMsTOxgPVrkEU8hojdkqqOsQBqQV
 x1GcNs1tIWs86I7+wnvd+Xlwd+zjK60iocaoU21SdtTEIyhQAw
 pVp4zohC9W8G9Fcb2M+y3jXHWTvdnJlOXrKwmLaOJoy1X7Rb44
 Kys8DZf27+kEQ7ljUtpVIBMJ9R2uowaT/uXBz4JSB3t2MS5vzg
 VcOJ0lQ/TxMl4nmWxx1k3P1COsXAobSG0vrq0V64PrbBUPHYcm
 SgnQmZBXaFJPDHzulKXYRGIWGCvtuuK0URNJdQduhWmTpG6orP
 r3CFXv1+SgRMlzoWQqu3G0Ii/g7ZCWJ9sVxJ2znMblr7GTY6Pt
 uFaTsrbX2Kv39vO1M0j8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> On 10/24/2012 01:48 PM, Gregory CLEMENT wrote:
> > On 10/24/2012 01:36 PM, Arnd Bergmann wrote:
> >>
> >> I think it would be cleaner to statically define the operations in a constant
> >> structure and point directly to the functions you need. If necessary, use
> >> multiple structures.
> > 
> > My problem was that these functions are not exposed, only arm_dma_op and
> > arm_coherent_dma_ops are exported.
> > Or do you think about something like this:
>
> struct dma_map_ops *dma_ops = {
>         .alloc                  = arm_coherent_dma_ops.arm_coherent_dma_alloc,
>         .free                   = arm_coherent_dma_ops.arm_coherent_dma_free,
>         .mmap                   = arm_coherent_dma_ops.arm_dma_mmap,
>         .get_sgtable            = arm_coherent_dma_ops.arm_dma_get_sgtable,
>         .map_sg                 = arm_coherent_dma_ops.arm_dma_map_sg,
>         .set_dma_mask           = arm_coherent_dma_ops.arm_dma_set_mask,
>         .map_page               = armada_xp_dma_map_page,
>         .unmap_page             = armada_xp_dma_unmap_page,
>         .unmap_sg               = arm_dma_ops.unmap_sg,
>         .sync_single_for_cpu    = armada_xp_dma_sync,
>         .sync_single_for_device = armada_xp_dma_sync,
>         .sync_sg_for_cpu        = arm_dma_ops.sync_sg_for_cpu,
>         .sync_sg_for_device     = arm_dma_ops.sync_sg_for_device,
> };

No, I was thinking of making the underlying functions globally visible
and have extern declarations in a header file so you can access them
directly.

Generally speaking, when you run into a problem with common code, your
first approach should be to fix the common code before you try to work
around it.

	Arnd
