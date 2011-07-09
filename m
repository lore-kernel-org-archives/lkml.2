Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1GIO7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:59:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51163 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1GIO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:59:08 -0400
Date: Sat, 9 Jul 2011 15:58:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: nico@fluxnic.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: move ARCH_HAS_DMA_SET_COHERENT_MASK into
	memory.h
Message-ID: <20110709145856.GM4812@n2100.arm.linux.org.uk>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <1309366019-24379-3-git-send-email-robherring2@gmail.com> <4E1866A2.9040407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1866A2.9040407@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 09:33:06AM -0500, Rob Herring wrote:
> I noticed this is going to have conflicts with your ARM_DMA_ZONE_SIZE
> series. Can you add this into your series? This still presents another
> issue to solve for single kernel binary, but hopefully the dma mapping
> work will help.

That's a different problem - its about limiting the maximum DMA mask
which can be set, so that memory is sourced from the right place
even for drivers which use 32-bit masks.

It's needed to ensure that dma_set_coherent_mask() can be overridden.
One solution to it would be to ensure that we always define
ARCH_HAS_DMA_SET_COHERENT_MASK, and handle the differences internally,
which is something I've been thinking about adding to my DMA bounce
series of patches.
