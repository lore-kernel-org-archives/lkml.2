Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0EROC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:02:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48016 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0EROC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:02:26 -0400
From: Sebastien Jan <s-jan@ti.com>
Organization: Texas Instruments
To: Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [RFC PATCHv2 2/7] OMAP SSI: Introducing OMAP SSI driver
Date: Tue, 18 May 2010 16:05:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com> <201005141641.59244.s-jan@ti.com> <1274173640.7755.22703.camel@localhost>
In-Reply-To: <1274173640.7755.22703.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005181605.55809.s-jan@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 May 2010 11:07:20 Carlos Chinea wrote:
[cut]
> > > +       val |= __raw_readl(omap_ssi->sys +
> > > SSI_MPU_ENABLE_REG(port->num, 0)); +       __raw_writel(val,
> > > omap_ssi->sys +
> > >  SSI_MPU_ENABLE_REG(port->num, 0)); +
> > > +       msg->status = HSI_STATUS_COMPLETED;
> > > +       msg->actual_len = sg_dma_len(msg->sgt.sgl);
> > > +       spin_unlock(&omap_ssi->lock);
> > > +}
> >
> > Don't you need to check the queue related to this transfer at this point,
> > to start the potentially next queued transfer on the same channel?
> > (calling ssi_start_transfer(), like in ssi_pio_complete()?)
> 
> No this is done in ssi_pio_complete(). Notice that we do not call the
> complete callback at any point here. We just arm the pio interrupt for
> that channel and transfer direction. AFAIK, this is the SW logic
> expected by the OMAP SSI HW.

Ok, though I would not expect the interrupt to fire in an Rx scenario as the 
fifo would have already been emptied by the DMA for this transfer (unless you 
rely on the next transfer initiated by the peer to make the Rx interrupt fire 
on this channel?)?
