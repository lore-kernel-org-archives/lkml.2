Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab1D1N4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:56:24 -0400
Received: from 8bytes.org ([88.198.83.132]:45968 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1D1N4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:56:23 -0400
Date: Thu, 28 Apr 2011 15:56:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428135621.GE13402@8bytes.org>
References: <201104212129.17013.arnd@arndb.de> <20110428122508.GC13402@8bytes.org> <20110428124242.GJ17290@n2100.arm.linux.org.uk> <201104281502.16296.arnd@arndb.de> <20110428131928.GL17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428131928.GL17290@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:19:28PM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 28, 2011 at 03:02:16PM +0200, Arnd Bergmann wrote:

> You still need this same cache handling code even when you don't have
> an iommu.

You can reference the same code from different places.

> I don't see the point in having a dma_ops level of indirection
> followed by a separate iommu_ops level of indirection - it seems to me
> to be a waste of code and CPU time, and I don't see why its even
> necessary when there's a much simpler way to deal with it (as I
> illustrated).

There is no waste of code, just the opposite. Most of the dma_ops
implementations that use an IOMMU today have a lot of similiarities in
their code. All this code (on x86, alpha, sparc, ia64, ...) can
be unified to a generic solution that fits all (by abstracting the
differences between iommus into the iommu-api). So the current situation
is a much bigger code waste than having this unified. The ARM platforms
supporting iommu hardware will benefit from this as well. It simply
doesn't make sense to have one dma_ops implementation for each iommu
hardware around.

Regards,

	Joerg

