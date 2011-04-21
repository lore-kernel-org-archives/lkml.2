Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1DUT3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:29:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1DUT3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:29:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Subject: [RFC] ARM DMA mapping TODO, v1
Date: Thu, 21 Apr 2011 21:29:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104212129.17013.arnd@arndb.de>
X-Provags-ID: V02:K0:IXOvwdSNta7Y/D8F1cG+0Own6kUOvcceQJzlsTBmn6z
 cTS+krsssY0wAqXBGQ9610+DMahx6NKMMUwTtu/jMF+HB4XUAz
 XSlDUwEI1J0EkQDtGX8IDVnrShrQ9DhHWVAUk0khezt/h2d4oB
 HnEMjciNgFyR63TGSzOzi8KbFmoCaEhaspjXWZKHuGVwc1Dg9G
 axP8Xe/6HBYO9WbDELOxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the recent discussions on linaro-mm-sig and the BoF last week
at ELC have been quite productive, and at least my understanding
of the missing pieces has improved quite a bit. This is a list of
things that I think need to be done in the kernel. Please complain
if any of these still seem controversial:

1. Fix the arm version of dma_alloc_coherent. It's in use today and
   is broken on modern CPUs because it results in both cached and
   uncached mappings. Rebecca suggested different approaches how to
   get there.

2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
   that this is needed, and it currently is not implemented, with
   an outdated comment explaining why it used to not be possible
   to do it.

3. Convert ARM to use asm-generic/dma-mapping-common.h. We need
   both IOMMU and direct mapped DMA on some machines.

4. Implement an architecture independent version of dma_map_ops
   based on the iommu.h API. As Joerg mentioned, this has been
   missing for some time, and it would be better to do it once
   than for each IOMMU separately. This is probably a lot of work.

5. Find a way to define per-device IOMMUs, if that is not actually
   possible already. We had conflicting statements for this.

6. Implement iommu_ops for each of the ARM platforms that has
   an IOMMU. Needs some modifications for MSM and a rewrite for
   OMAP. Implementation for Samsung is under work.

7. Extend the dma_map_ops to have a way for mapping a buffer
   from dma_alloc_{non,}coherent into user space. We have not
   discussed that yet, but after thinking this for some time, I
   believe this would be the right approach to map buffers into
   user space from code that doesn't care about the underlying
   hardware.

After all these are in place, building anything on top of
dma_alloc_{non,}coherent should be much easier. The question
of passing buffers between V4L and DRM is still completely
unsolved as far as I can tell, but that discussion might become
more focused if we can agree on the above points and assume
that it will be done.

I expect that I will have to update the list above as people
point out mistakes in my assumptions.

	Arnd
