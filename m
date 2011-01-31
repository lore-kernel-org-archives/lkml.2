Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1AaQgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:36:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:55989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1AaQgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:36:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,404,1291622400"; 
   d="scan'208";a="598096517"
Date: Mon, 31 Jan 2011 08:36:39 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: b44 driver causes panic when using swiotlb
Message-ID: <20110131163639.GA32095@tassilo.jf.intel.com>
References: <20110131105412.7252a09c@katamari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131105412.7252a09c@katamari>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 10:54:12AM -0500, Chuck Ebbert wrote:
> The b44 driver is triggering this panic in swiotlb_map_page():
> 
>         if (!dma_capable(dev, dev_addr, size))
>                 panic("map_single: bounce buffer is not DMA'ble");
> 
> The kernel log says the bounce buffers are at 0xdb400000, but b44 can
> only do DMA to the first 1GB of memory:

b44 needs to use GFP_DMA then and do its own custom bouncing. 
The standard pci_map_* bounce buffering is only designed for at least
32bit capable devices.

BTW I'm pretty sure this worked at some point, must have regressed 
somehow.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
