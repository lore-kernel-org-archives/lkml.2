Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0EZH0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:26:13 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55024 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0EZH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:26:09 -0400
Subject: Re: [RFC PATCHv2 2/7] OMAP SSI: Introducing OMAP SSI driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sebastien Jan <s-jan@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <201005181605.55809.s-jan@ti.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
	 <201005141641.59244.s-jan@ti.com> <1274173640.7755.22703.camel@localhost>
	 <201005181605.55809.s-jan@ti.com>
Content-Type: text/plain
Date: Wed, 26 May 2010 10:27:13 +0300
Message-Id: <1274858833.8099.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2010 07:24:26.0195 (UTC) FILETIME=[789E3230:01CAFCA4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 16:05 +0200, ext Sebastien Jan wrote:
> On Tuesday 18 May 2010 11:07:20 Carlos Chinea wrote:
> [cut]
> > > > +       val |= __raw_readl(omap_ssi->sys +
> > > > SSI_MPU_ENABLE_REG(port->num, 0)); +       __raw_writel(val,
> > > > omap_ssi->sys +
> > > >  SSI_MPU_ENABLE_REG(port->num, 0)); +
> > > > +       msg->status = HSI_STATUS_COMPLETED;
> > > > +       msg->actual_len = sg_dma_len(msg->sgt.sgl);
> > > > +       spin_unlock(&omap_ssi->lock);
> > > > +}
> > >
> > > Don't you need to check the queue related to this transfer at this point,
> > > to start the potentially next queued transfer on the same channel?
> > > (calling ssi_start_transfer(), like in ssi_pio_complete()?)
> > 
> > No this is done in ssi_pio_complete(). Notice that we do not call the
> > complete callback at any point here. We just arm the pio interrupt for
> > that channel and transfer direction. AFAIK, this is the SW logic
> > expected by the OMAP SSI HW.
> 
> Ok, though I would not expect the interrupt to fire in an Rx scenario as the 
> fifo would have already been emptied by the DMA for this transfer (unless you 
> rely on the next transfer initiated by the peer to make the Rx interrupt fire 
> on this channel?)?

No I do not rely on the next RX transfer. I rely on the fact that the
GDD(DMA) controller does not reset the RX status bit for that channel
when RX transfer is finished.

Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

