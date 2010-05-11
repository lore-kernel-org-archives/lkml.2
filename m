Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0EKPGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:06:18 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55962 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0EKPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:06:16 -0400
Date: Tue, 11 May 2010 17:05:57 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       USB list <linux-usb@vger.kernel.org>, tiwai@suse.de, gregkh@suse.de,
       clemens@ladisch.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       andi@firstfloor.org, pedrib@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
Message-ID: <20100511150557.GY30801@buzzloop.caiaq.de>
References: <20100511142439.GA4898@phenom.dumpdata.com>
 <Pine.LNX.4.44L0.1005111052260.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005111052260.1834-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 10:57:07AM -0400, Alan Stern wrote:
> There are no calls to any dma_sync_* routines.  Daniel will have to
> check me on this, but I believe that urb->transfer_buffer is filled
> before dma_map_single() is called and it isn't touched again until
> after dma_unmap_single() (which occurs before urb's completion handler
> is called).

Yes, that's correct. Sorry fot the misleading information I gave. The
code doesn't to any weird tricks as it currently stands. It fills the
buffer, submits the URB and doesn't touch the buffer contents
afterwards.

Daniel

