Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab1D1OkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:40:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1D1OkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:40:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Thu, 28 Apr 2011 16:39:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <201104281629.52863.arnd@arndb.de> <20110428143440.GP17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428143440.GP17290@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281640.00107.arnd@arndb.de>
X-Provags-ID: V02:K0:fCYHfTdKIHApb97j6POKJtU4O3f82Cw1c/etTM5NqpY
 kzhk0LEo4H2ud169CmeLTvq3rQqLCdJ98pT0C/G/ri4ERKlsnD
 2zd3NcyNm3/GyM2eo4PrmNdOOLuUWIlgAFwL6p9f/coXSMXlN1
 jKihWdxV1em7gv6r4nhZk0876BbGsjCFC4bACcbCC4WaMPdSlT
 KmJWM4X1C2OwFJh/Hqdkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Russell King - ARM Linux wrote:
> On Thu, Apr 28, 2011 at 04:29:52PM +0200, Arnd Bergmann wrote:
> > Given that people still want to have an interface that does what I
> > though this one did, I guess we have two options:
> > 
> > * Kill off dma_cache_sync and replace it with calls to dma_sync_*
> >   so we can start using dma_alloc_noncoherent on ARM
> 
> I don't think this is an option as dma_sync_*() is part of the streaming
> DMA mapping API (dma_map_*) which participates in the idea of buffer
> ownership, which the noncoherent API doesn't appear to.

I thought the problem was in fact that the noncoherent API cannot be
implemented on architectures like ARM specifically because there is
no concept of buffer ownership. The obvious way to fix that would
be to redefine the API. What am I missing?

	Arnd
