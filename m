Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2BMMRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 07:17:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2BMMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 07:17:39 -0500
Date: Mon, 13 Feb 2012 13:17:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Felipe Balbi <balbi@ti.com>
cc: linux-usb@vger.kernel.org,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 2/2] usb: fix renesas_usbhs to not schedule in atomic
 context
In-Reply-To: <20120213120814.GP6614@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.64.1202131316220.8277@axis700.grange>
References: <Pine.LNX.4.64.1202092313560.18719@axis700.grange>
 <Pine.LNX.4.64.1202092316180.18719@axis700.grange>
 <20120213120814.GP6614@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ydKxEdLKR9tuaFuZLOAeFE7as3bzAlZtuccyXn5l3om
 5Ezch/vVjwSOd+L0Z6S7TGOkxp0emlh+MdW5bf2oYMKffD4P3O
 MPS3M1z8yp0JW97n4FZ0HAOKvif+1zAC1b4+LZ+tW8hV0oZFzv
 HBg035CJyq3/lLeDwS3RTZgw5bnwtWG9T03yK3AOMJRIJX+WBd
 acLI2T+wIKIE1q7Ne1JhGcceDgSGqdxqqccJiWNAaHlcbqhI95
 Q5wME15jIV5SGGR03V3e9JOmGPwIjr/KyWkXU9N7b3o/TqXXH3
 z3VVytbk/IQYYGeJiGuRJ1TSMVO9sffj4MJRfuv10mb0Kp8o3c
 fH93Kma8UdpQKu5fCrEr03mS4BJG4epgclXxqkMeuafmjbML3S
 +gWFfWLY14fuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012, Felipe Balbi wrote:

> Hi,
> 
> On Thu, Feb 09, 2012 at 11:17:51PM +0100, Guennadi Liakhovetski wrote:
> > @@ -997,7 +991,7 @@ static bool usbhsf_dma_filter(struct dma_chan *chan, void *param)
> >  	 *
> >  	 * usbhs doesn't recognize id = 0 as valid DMA
> >  	 */
> > -	if (0 == slave->slave_id)
> > +	if (0 == slave->simple_slave.slave_id)
> >  		return false;
> >  
> >  	chan->private = slave;
> > @@ -1176,8 +1170,8 @@ int usbhs_fifo_probe(struct usbhs_priv *priv)
> >  	fifo->port	= D0FIFO;
> >  	fifo->sel	= D0FIFOSEL;
> >  	fifo->ctr	= D0FIFOCTR;
> > -	fifo->tx_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
> > -	fifo->rx_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
> > +	fifo->tx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d0_tx_id);
> > +	fifo->rx_slave.simple_slave.slave_id	= usbhs_get_dparam(priv, d0_rx_id);
> 
> what are these "simple_slave" changes ? They have nothing to do with
> $SUBJECT ? In fact, breaks my gadget branch.

Hrrrm... Right, sorry, that's clearly unrelated...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
