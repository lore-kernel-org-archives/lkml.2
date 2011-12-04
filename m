Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1LDQ7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 11:59:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39864 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753081Ab1LDQ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 11:59:33 -0500
Date: Sun, 4 Dec 2011 11:59:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: fix number of mapped SG DMA entries
In-Reply-To: <4EDAA59B.6080900@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.1112041157370.32730-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Dec 2011, Clemens Ladisch wrote:

> Add a new field num_mapped_sgs to struct urb so that we have a place to
> store the number of mapped entries and can also retain the original
> value of entries in num_sgs.  Previously, usb_hcd_map_urb_for_dma()
> would overwrite this with the number of mapped entries, which would
> break dma_unmap_sg() because it requires the original number of entries.
> 
> This fixes warnings like the following when using USB storage devices:
>  ------------[ cut here ]------------
>  WARNING: at lib/dma-debug.c:902 check_unmap+0x4e4/0x695()
>  ehci_hcd 0000:00:12.2: DMA-API: device driver frees DMA sg list with different entry count [map count=4] [unmap count=1]

Interesting.  Do you have any idea why this warning didn't show up 
earlier?  Is there perhaps a Kconfig option I ought to be using?

Alan Stern

