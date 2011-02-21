Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1BUOqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:46:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab1BUOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:46:00 -0500
Date: Mon, 21 Feb 2011 14:45:40 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>, nicolas.ferre@atmel.com
Subject: Re: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst
 masters
Message-ID: <20110221144539.GD2744@pulham.picochip.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
 <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
 <1298295901.24505.68.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298295901.24505.68.camel@hcegtvedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 02:45:00PM +0100, Hans-Christian Egtvedt wrote:
> On Fri, 2011-01-21 at 14:11 +0000, Jamie Iles wrote: 
> > Now that the dw_dmac DMA driver supports configurable source and
> > destination masters we need to specify which ones to use. This was
> > previously hardcoded to 0 and 1 respectively in the driver.
> > 
> > Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> > ---
> >  arch/avr32/mach-at32ap/at32ap700x.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> > index e67c999..2747cde 100644
> > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > @@ -2048,6 +2048,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
> >  		rx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
> >  		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
> >  		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
> > +		rx_dws->src_master = 0;
> > +		rx_dws->dst_master = 1;
> >  	}
> >  
> >  	/* Check if DMA slave interface for playback should be configured. */
> > @@ -2056,6 +2058,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
> >  		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
> >  		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
> >  		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
> > +		rx_dws->src_master = 0;
> > +		rx_dws->dst_master = 1;
> 
> Spotted by Nicolas Ferre, you use the wrong struct here, should be
> tx_dws, not rx_dws.

Apologies, here's a patch to fix it up.

Jamie

8<--------

>From 9068d500450ad6f5189b9a71463851349700c505 Mon Sep 17 00:00:00 2001
From: Jamie Iles <jamie@jamieiles.com>
Date: Mon, 21 Feb 2011 14:38:32 +0000
Subject: [PATCH] avr32: at32ap700x: fix typo in DMA master configuration

Commit 4aa5f366431fe (avr32: at32ap700x: specify DMA src and dst
masters) specified the masters for the ac97c playback device
but incorrectly set them in the capture slave information rather
than playback.

Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 2747cde..4635c7c 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -2058,8 +2058,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
-		rx_dws->src_master = 0;
-		rx_dws->dst_master = 1;
+		tx_dws->src_master = 0;
+		tx_dws->dst_master = 1;
 	}
 
 	if (platform_device_add_data(pdev, data,
-- 
1.7.4

