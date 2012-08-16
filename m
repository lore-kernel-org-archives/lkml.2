Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2HPKkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:40:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13777 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2HPKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:40:17 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-cb-502cce0f5de5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hideki EIRAKU'" <hdk@igel.co.jp>
Cc: laurent.pinchart@ideasonboard.com, linux@arm.linux.org.uk,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@infradead.org,
        FlorianSchandinat@gmx.de, perex@perex.cz, tiwai@suse.de,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, matsu@igel.co.jp, dhobsong@igel.co.jp
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
 <1344246924-32620-4-git-send-email-hdk@igel.co.jp>
 <012701cd74ac$6a617060$3f245120$%szyprowski@samsung.com>
 <20120816.191358.127675610.hdk@igel.co.jp>
In-reply-to: <20120816.191358.127675610.hdk@igel.co.jp>
Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent
 if available
Date: Thu, 16 Aug 2012 12:39:57 +0200
Organization: SPRC
Message-id: <015b01cd7b9b$8010e2b0$8032a810$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac17l99JsboOf4qRTvSAr8cw/axfbwAA01hA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jAV3+czoBBr0PNCxO9H1gtbi8aw6b
	Rc+GrawOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZcw63M5ccJ234tb85ewNjOu5uxg5OSQETCS2
	HDzDBGGLSVy4t56ti5GLQ0hgEaPEpnfnmCCcn4wSTxd2gVWxCRhKdL3tYgOxRQRUJJZ8PcMK
	YjML7GCWePK3DqLhNqNEz55bQAkODk4Bc4nP/bwgNcICsRK9B/eygNgsAqoS659tYgMp4RcQ
	kpg4SwEkzCvgIrFoUwcLhC0o8WPyPRaI8VoS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLsQ1RhKv
	50yEukZE4m7Dc9YJjMKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOOSfSe9gXNVgcYhRgINRiYf3wH/tACHWxLLiytxDjBIczEoivLdrdQKEeFMSK6tSi/Lj
	i0pzUosPMUpzsCiJ85p4f/UXEkhPLEnNTk0tSC2CyTJxcEo1MPIL3w753uo46WC1Qvy709fZ
	xOWkTV+0LX+4MmPL4ywu9VmfnWPM7/DqLH4WYnHI4MPpMp9AkdB70+RXrDcLUasIKknXWmPz
	aHFlkKTTnQfPhSf8cZOK3qJX+LSjIzWvI8bgqwvD1K8bW/aXvfEvEVrM83itwKv9f+YaXXUx
	/3FJe/G/2+Yct5VYijMSDbWYi4oTAcwx4uZ1AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, August 16, 2012 12:14 PM Hideki EIRAKU wrote:

> From: Marek Szyprowski <m.szyprowski@samsung.com>
> Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent if available
> Date: Tue, 07 Aug 2012 16:53:25 +0200
> 
> > I'm sorry for bringing this issue now, once you have already created v3 of your
> > patches, but similar patch has been already proposed some time ago. It is already
> > processed together with general videobuf2-dma-contig redesign and dma-buf extensions
> > by Tomasz Stanislawski.
> >
> > See post http://thread.gmane.org/gmane.comp.video.dri.devel/70402/focus=49461 and
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/49438
> >
> > It doesn't use conditional code inside videobuf2 allocator and rely entirely on
> > dma-mapping subsystem to provide a working dma_mmap_coherent/writecombine/attrs()
> > function. When it was posted, it relied on the dma-mapping extensions, which now
> > have been finally merged to v3.6-rc1. Now I wonder if there are any architectures,
> > which don't use dma_map_ops based dma-mapping framework, which might use
> > videobuf2-dma-conting module.
> 
> Thank you for telling me about videobuf2-dma-contig and v3.6-rc1.  The
> videobuf2-dma-contig patch I sent is now unnecessary.  So I will
> remove the patch.  I will remove the patch defining
> ARCH_HAS_DMA_MMAP_COHERENT too because the v3.6-rc1 kernel has generic
> dma_mmap_coherent() API for every architecture.

Just to let you know - Tomasz has posted an updated version of the dma-buf/vb2-dma-contig
patches:

http://www.spinics.net/lists/linux-media/msg51768.html

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


