Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1IOIXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:23:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1IOIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 04:23:12 -0400
Date: Thu, 15 Sep 2011 09:22:53 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org, 21cnbao@gmail.com
Subject: Re: [PATCHv2] DMAEngine: Define generic transfer request api
Message-ID: <20110915082252.GB30518@flint.arm.linux.org.uk>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org> <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 01:16:29PM +0530, Jassi Brar wrote:
> +/**
> + * struct dmaxfer_template - Template to convey DMAC the transfer pattern
> + *	 and attributes.
> + * @src_start: Bus address of source for the first chunk.
> + * @dst_start: Bus address of destination for the first chunk.
> + * @src_inc: If the source address increments after reading from it.
> + * @dst_inc: If the destination address increments after writing to it.
> + * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
> + *		Otherwise, source is read contiguously (icg ignored).
> + *		Ignored if src_inc is false.
> + * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
> + *		Otherwise, destination is filled contiguously (icg ignored).
> + *		Ignored if dst_inc is false.
> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
> + * @numf: Number of frames in this template.
> + * @frame_size: Number of chunks in a frame i.e, size of sgl[].
> + * @sgl: Array of {chunk,icg} pairs that make up a frame.
> + */
> +struct dmaxfer_template {
> +	dma_addr_t src_start;
> +	dma_addr_t dst_start;
> +	bool src_inc;
> +	bool dst_inc;
> +	bool src_sgl;
> +	bool dst_sgl;
> +	bool frm_irq;

I'll ask again.  How does this deal with the XOR operation, where you have
two sources and one destination?  Unless you sort that out, I don't see
how your idea of collapsing all the prepare functions can possibly work.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
