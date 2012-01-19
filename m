Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2ASI7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:59:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64215 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2ASI7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:59:11 -0500
Date: Thu, 19 Jan 2012 17:10:37 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Huang Shijie <b32955@freescale.com>
Cc: vinod.koul@intel.com, artem.bityutskiy@intel.com, shijie8@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, LW@KARO-electronics.de,
        alsa-devel@alsa-project.org, b29396@freescale.com
Subject: Re: [PATCH 00/10] patch set about the MXS-DMA
Message-ID: <20120119091034.GH2247@S2101-09.ap.freescale.net>
References: <1326953767-24155-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326953767-24155-1-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:15:57PM +0800, Huang Shijie wrote:
> This patch set does two things about the MXS-DMA:
> [1] patch 1 ~ patch 5: move the mxs dma header to a more common place.
> 	Beside the mx23/mx28, the APBH-DMA is also used by MX50 and MX6Q.
> 	So move the mxs dma header file to a more common place, and rename
> 	it to mxs-dma.h
> 
For the sake of bitsec, these 5 patches need to be one.

> [2] patch 6 ~ patch 10: rewrite the last parameter of mxs_dma_prep_slave_sg().

For the sake of bitsec, at least patches #7 and #8 need to be one patch.
That said, if I apply the series and then check out the commit at patch
#7, you need to all mxs-dma client drivers, mxs-mmc, gpmi do not break.

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
>          Please read the comment in patch "MXS-DMA : add more flags for MXS-DMA".
> 
> Huang Shijie (10):
>   MXS-DMA : move the mxs-dma.h to a more common place
>   MXS-DMA : change the header
>   MXS-MMC : change the DMA header file
>   MTD/GPMI : change the DMA header file
>   ASoc : change the DMA header file
>   MXS-DMA : add more flags for MXS-DMA
>   MXS-DMA : change the last parameter of mxs_dma_prep_slave_sg()
>   MXS-MMC : use the new DMA flags
>   MTD/GPMI : add a new field `gpmi_version`
>   MTD/GPMI : change the code for new DMA interface
> 
Please try to make these subject prefix consistent with the existing
ones in the tree.  You can get them from 'git log' output.  For example
"mxs-dma: ..." is better than "MXS-DMA : ...".

-- 
Regards,
Shawn
