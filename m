Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0HRQXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:23:34 -0400
Received: from stargate.synerway.com ([84.14.10.249]:53709 "EHLO
	kamino.synerway.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069Ab0HRQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:23:33 -0400
Date: Wed, 18 Aug 2010 18:23:29 +0200
From: Pascal GREGIS <pgs@synerway.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ata_sff_drain_fifo
Message-ID: <20100818162329.GC3029@gaiman.synerway.com>
References: <20100818094313.GA3333@gaiman.synerway.com> <20100818124412.4652eaea@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100818124412.4652eaea@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 18 Aug 2010 16:23:29.0006 (UTC) FILETIME=[B12280E0:01CB3EF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox a écrit, le mer 18 aoû 2010 à 12:44:12 :
> > so I guess when status is 0xD0, ATA_DRQ is not set but ATA_BUSY is.
> > It would explain why in my case it doesn't drain anything before trying to reset.
> > 
> > Would it be of any interest to drain the fifo also when the ATA_BUSY flag is on, not only the ATA_DRQ ?
> 
> If the drive has the busy flag set it is busy, all we can do is wait for
> it and if that fails try to reset it. The FIFO drain handles a specific
> case where the two ends disagree about the amount of data expected, and
> often lets us avoid a reset.
Ok. I also noticed that qc->dma_dir=DMA_TO_DEVICE which also prevents the draining.
I thought it could be a solution for certain problems like mine where the device is busy but the reset doesn't work which brings to a blocking point, but no.

Pascal

> 
> Alan
