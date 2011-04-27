Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057Ab1D0Vg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:36:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:39734 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab1D0VgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:36:23 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201104212129.17013.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 07:31:06 +1000
Message-ID: <1303939866.2513.180.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 21:29 +0200, Arnd Bergmann wrote:
> 
> 7. Extend the dma_map_ops to have a way for mapping a buffer
>    from dma_alloc_{non,}coherent into user space. We have not
>    discussed that yet, but after thinking this for some time, I
>    believe this would be the right approach to map buffers into
>    user space from code that doesn't care about the underlying
>    hardware.

Yes. There is a dma_mmap_coherent() call that's not part of the "Real"
API but is implemented by some archs and used by Alsa (I added support
for it on powerpc recently).

Maybe that should go into the dma ops.

The question remains, if we ever want to do more complex demand-paged
operations, should we also expose a lower level set of functions to get
struct page out of a dma_alloc_coherent() allocation and to get the
pgprot for the user dma mapping ?

> After all these are in place, building anything on top of
> dma_alloc_{non,}coherent should be much easier. The question
> of passing buffers between V4L and DRM is still completely
> unsolved as far as I can tell, but that discussion might become
> more focused if we can agree on the above points and assume
> that it will be done.

My gut feeling is that it should be done by having V4L use DRM buffers
in the first place...

> I expect that I will have to update the list above as people
> point out mistakes in my assumptions.

Cheers,
Ben.


