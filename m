Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0CYFoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:44:38 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:58963 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221Ab0CYFog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:44:36 -0400
Date: Thu, 25 Mar 2010 05:44:30 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dan.j.williams@intel.com, linus.ml.walleij@gmail.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
Message-ID: <20100325054430.165311fa@taxman.wild-wind.fr.eu.org>
In-Reply-To: <4BAAD5BB.7050101@samsung.com>
References: <4BAAD5BB.7050101@samsung.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: jy0922.shim@samsung.com, dan.j.williams@intel.com, linus.ml.walleij@gmail.com, kyungmin.park@samsung.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 12:17:15 +0900
Joonyoung Shim <jy0922.shim@samsung.com> wrote:

> +/* instruction set functions */
> +static inline int pl330_dmaaddh(u8 *desc_pool_virt, u16 imm, bool ra)
> +{
> +	u8 opcode = DMAADDH | (ra << 1);
> +
> +	writeb(opcode, desc_pool_virt++);

desc_pool_virt is a virtual address (from dma_alloc_coherent). In such
case, write[bwl] seems to be the wrong interface. I suggest the
following code:

	*desc_pool_virt++ = opcode;

> +	writew(imm, desc_pool_virt);

Does anything ensure that this won't generate an unaligned access?

> +	return 3;
> +}

	M.
-- 
I'm the slime oozin' out from your TV set...
