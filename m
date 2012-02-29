Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2B2DIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:08:17 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:49693
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755220Ab2B2DIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:08:16 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202h1082kzzz2dh2a8h668h839h941h35h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F4D9725.3090100@freescale.com>
Date: Wed, 29 Feb 2012 11:10:29 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: <vinod.koul@intel.com>, <shawn.guo@linaro.org>,
        <artem.bityutskiy@intel.com>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>, <cjb@laptop.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/2] patch set about the MXS-DMA
References: <1329373053-19494-1-git-send-email-b32955@freescale.com>
In-Reply-To: <1329373053-19494-1-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

ping.

Any comment about this patch set?

thanks
Huang Shijie
> patch 1: move the mxs dma header to a more common place.
> 	Beside the mx23/mx28, the apbh-dma is also used by MX50 and MX6Q.
> 	So move the mxs dma header file to a more common place, and rename
> 	it to mxs-dma.h
>
> patch 2: rewrite the last parameter of mxs_dma_prep_slave_sg().
> 	In the new GPMI version, some hardware behavior changes.
> 	The WAIT4END bit should be set in the middle one of the ECC READ page DMA chain.
> 	The DMA chain should be set like this:
>
>           +-----+               +-----+                      +-----+
>           | cmd | ------------> | cmd | ------------------>  | cmd |
>           +-----+               +-----+                      +-----+
>                                    ^                            ^
>                                    |                            |
>                                    |                            |
>                               set WAIT4END here too        set WAIT4END here
>
>         So rewrite the last parameter of mxs_dma_prep_slave_sg(), use the
> 	dma_ctrl_flags to set the proper DMA bit for DMA Command Structure.
> 	And change the relative drivers with the dma_ctrl_flags.
>
> TEST:
> 	Tested the mxs-mmc driver and gpmi-nand drive with the two patches
> 	in MX28 board.
>
> v5 --> v6:
> 	[1] create this patch set based on the mainline.
>
> v4 --> v5:
> 	[1] remove GPMI_IS_MX6Q(), make the mxs and mx6q use the same code.
> 		
> v3 --> v4:
> 	[1] create a new folder include/linux/fsl/ for store the Freescale's
> 	    header files.
> 	[2] add more CCs.
>
> v2 --> v3:
> 	[1] remove field gpmi_version, use GPMI_IS_MX6Q() instead.
>
> v1 --> v2:
> 	[1] squash the trial patches into single patch.
> 	[2] use the dma_ctrl_flags.
>
>
> Huang Shijie (2):
>   mxs-dma : move the mxs dma.h to a more common place
>   mxs-dma : rewrite the last parameter of mxs_dma_prep_slave_sg()
>
>  drivers/dma/mxs-dma.c                              |   34 +++++++++++++++++---
>  drivers/mmc/host/mxs-mmc.c                         |   12 +++---
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c              |   19 +++++++---
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
>  .../mach/dma.h => include/linux/fsl/mxs-dma.h      |    0
>  sound/soc/mxs/mxs-pcm.c                            |    2 +-
>  sound/soc/mxs/mxs-pcm.h                            |    2 +-
>  sound/soc/mxs/mxs-saif.c                           |    2 +-
>  8 files changed, 52 insertions(+), 21 deletions(-)
>  rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/fsl/mxs-dma.h (100%)
>


