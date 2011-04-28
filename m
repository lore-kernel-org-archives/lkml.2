Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1D1OfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:35:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55562 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1D1OfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:35:11 -0400
Date: Thu, 28 Apr 2011 15:34:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110428143440.GP17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de> <201104281428.56780.arnd@arndb.de> <20110428131531.GK17290@n2100.arm.linux.org.uk> <201104281629.52863.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104281629.52863.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 04:29:52PM +0200, Arnd Bergmann wrote:
> Given that people still want to have an interface that does what I
> though this one did, I guess we have two options:
> 
> * Kill off dma_cache_sync and replace it with calls to dma_sync_*
>   so we can start using dma_alloc_noncoherent on ARM

I don't think this is an option as dma_sync_*() is part of the streaming
DMA mapping API (dma_map_*) which participates in the idea of buffer
ownership, which the noncoherent API doesn't appear to.
