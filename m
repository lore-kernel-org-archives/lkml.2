Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0EJCwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 22:52:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:52380 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0EJCwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 22:52:36 -0400
Date: Mon, 10 May 2010 11:50:56 +0900
To: stern@rowland.harvard.edu
Cc: daniel@caiaq.de, clemens@ladisch.de, tiwai@suse.de,
       alsa-devel@alsa-project.org, gregkh@suse.de, konrad.wilk@oracle.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, pedrib@gmail.com, akpm@linux-foundation.org,
       dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.44L0.1005071048220.1804-100000@iolanthe.rowland.org>
References: <20100507102408.GM30801@buzzloop.caiaq.de>
	<Pine.LNX.4.44L0.1005071048220.1804-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100510115048E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 May 2010 11:51:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010 10:51:10 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 7 May 2010, Daniel Mack wrote:
> 
> > > At least the audio class and ua101 drivers don't do this and fill the
> > > buffers before they are submitted.
> > 
> > Gnaa, you're right. I _thought_ my code does it the way I described, but
> > what I wrote is how I _wanted_ to do it, not how it's currently done. I
> > have a plan to change this in the future.
> > 
> > So unfortunately, that doesn't explain it either. Sorry for the noise.
> 
> At one point we tried an experiment, printing out the buffer and DMA 
> addresses.  I don't recall seeing anything obviously wrong, but if an 
> IOMMU was in use then that might not mean anything.  Is it possible 
> that the IOMMU mappings sometimes get messed up for addresses above 4 
> GB?

You mean that an IOMMU could allocate an address above 4GB wrongly? If
so, IIRC, all the IOMMU implementations use dev->dma_mask and
dev->coherent_dma_mask properly. And the DMA address space of the
majority of IOMMUs are limited less than 4GB.
