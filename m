Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab1D1NTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:19:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53045 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1D1NTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:19:37 -0400
Date: Thu, 28 Apr 2011 14:19:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joro@8bytes.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428131928.GL17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <20110428122508.GC13402@8bytes.org> <20110428124242.GJ17290@n2100.arm.linux.org.uk> <201104281502.16296.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201104281502.16296.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 03:02:16PM +0200, Arnd Bergmann wrote:
> I think the misunderstanding is that you are saying we need the flag
> in dma_map_ops because you prefer to keep the cache management outside
> of the individual dma_map_ops implementations.
> 
> What I guess Jörg is thinking of is to have the generic IOMMU version
> of dma_map_ops call into the architecture specific code to manage the
> caches on architectures that need it. That implementation would of
> course not require the flag in dma_map_ops because the architecture
> specific callback would use other ways (hardcoded for an architecture,
> or looking at the individual device) to determine if this is ever needed.
> 
> That is also what I had in mind earlier, but you argued against it
> on the base that putting the logic into the common code would lead
> to a higher risk of people accidentally breaking it when they only
> care about coherent architectures.

You still need this same cache handling code even when you don't have
an iommu.  I don't see the point in having a dma_ops level of indirection
followed by a separate iommu_ops level of indirection - it seems to me to
be a waste of code and CPU time, and I don't see why its even necessary
when there's a much simpler way to deal with it (as I illustrated).
