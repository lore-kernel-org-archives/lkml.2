Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2G3Ucq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:32:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55000 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2G3Uco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:32:44 -0400
Date: Mon, 30 Jul 2012 22:34:32 +0200
From: karl.beldan@gmail.com
To: linux-kernel@vger.kernel.org
Cc: karl.beldan@gmail.com
Subject: Re: About dma_sync_single_for_{cpu,device}
Message-ID: <20120730203412.GA5311@gobelin>
References: <20120730202401.GA4947@gobelin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120730202401.GA4947@gobelin>
X-Location: France
User-Agent: Mutt (Linux 3.5.0-07078-gf7da9cd-dirty x86_64 GNU/Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:24:01PM +0200, karl.beldan@gmail.com wrote:
> I was expecting the following to work:
> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);

Sorry, I forgot this (invalidate):
 	dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);

> 	dev_send(buffer);
> 	// wait for irq (don't peek in the buffer) ... got irq
> 	dma_sync_single_single_for_cpu(dev, buffer, pattern_size, DMA_FROM_DEVICE);
> 	if (!xfer_done(buffer)) // not RAM value
> 		dma_sync_single_for_device(dev, buffer, pattern_size, DMA_FROM_DEVICE);
> 	[...]

 
Karl
