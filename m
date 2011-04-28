Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1D1NCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:02:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55277 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1D1NCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:02:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 15:02:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Joerg Roedel <joro@8bytes.org>, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110428122508.GC13402@8bytes.org> <20110428124242.GJ17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428124242.GJ17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201104281502.16296.arnd@arndb.de>
X-Provags-ID: V02:K0:IAZKP+FwVtlzxJzpek/DK1eSmbcP27mRU6gaoWO6ed7
 rmjoQHk0PyP0vmtqXWC4fC6atYEaed3jRThlfK1hLqJZoM+Wju
 LmhZdxzP405IGbHYpEK4OohhRVpN9iST8STA4NS0WS/L9XEdnL
 EWa9bLG/pd7++xS1w0TbL0hgfGNbl2whliU0dbIxIUMnZ9u6D1
 bM0AUSoF4dGfo3OlsvM/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> > 
> > Do we need flags for that? A flag is necessary if the cache-management
> > differs between IOMMU implementations on the same platform. If
> > cache-management is only specific to the platform (or architecture) then
> > it does make more sense to just call the function without flag checking
> > and every platform with coherent DMA just implements these as static
> > inline noops.
> 
> Sigh.  You're not seeing the point.
> 
> There is no point doing the cache management if we're using something
> like dmabounce or swiotlb, as we'll be using memcpy() at some point with
> the buffer.  Moreover, dmabounce or swiotlb may have to do its own cache
> management after that memcpy() to ensure that the page cache requirements
> are met.

I think the misunderstanding is that you are saying we need the flag
in dma_map_ops because you prefer to keep the cache management outside
of the individual dma_map_ops implementations.

What I guess Jörg is thinking of is to have the generic IOMMU version
of dma_map_ops call into the architecture specific code to manage the
caches on architectures that need it. That implementation would of
course not require the flag in dma_map_ops because the architecture
specific callback would use other ways (hardcoded for an architecture,
or looking at the individual device) to determine if this is ever needed.

That is also what I had in mind earlier, but you argued against it
on the base that putting the logic into the common code would lead
to a higher risk of people accidentally breaking it when they only
care about coherent architectures.

	Arnd
