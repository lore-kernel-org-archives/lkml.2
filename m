Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab2BASWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:22:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57075 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab2BASWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:22:22 -0500
Date: Wed, 1 Feb 2012 18:22:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: care sd_dma_address/len in
	dmaengine_prep_slave_single()
Message-ID: <20120201182201.GE889@n2100.arm.linux.org.uk>
References: <8739axwnh9.wl%kuninori.morimoto.gx@renesas.com> <1327917366.1527.42.camel@vkoul-udesk3> <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqe04qtk.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 05:13:30PM -0800, Kuninori Morimoto wrote:
> +	sg_init_table(&sg, 1);
> +	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf)),
> +		    len, offset_in_page(buf));

There's not much point setting this - the page/virtual address should
not be used by DMA engines as that may not reflect what's being requested
(especially if there's an IOMMU in the way.)
