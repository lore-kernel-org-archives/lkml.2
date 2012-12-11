Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab2LKNuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:50:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35515 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2LKNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:50:07 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Tue, 11 Dec 2012 14:54:44 +0100
Message-ID: <1535483.0HokefWAdm@harkonnen>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BF5950.2040805@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1685240.Ttn3DTWMJc@harkonnen> <50BF5950.2040805@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late answer to this.

> > This allocator is needed because some device (like STA2X11 VIP) cannot
> > work
> > with DMA sg or DMA coherent. Some other device (like the one used by
> > Jonathan when he proposes vb2-dma-nc allocator) can obtain much better
> > performance with DMA streaming than coherent.
> 
> Ok, please add such explanations at the patch's descriptions, as it is
> important not only for me, but to others that may need to use it..

OK

> >> 	2) why vb2-dma-config can't be patched to use dma_map_single
> >> 
> >> (eventually using a different vb2_io_modes bit?);
> > 
> > I did not modify vb2-dma-contig because I was thinking that each DMA
> > memory
> > allocator should reflect a DMA API.
> 
> The basic reason for having more than one VB low-level handling (vb2 was
> inspired on this concept) is that some DMA APIs are very different than
> the other ones (see vmalloc x DMA S/G for example).
> 
> I didn't make a diff between videobuf2-dma-streaming and
> videobuf2-dma-contig, so I can't tell if it makes sense to merge them or
> not, but the above argument seems too weak. I was expecting for a technical
> reason why it wouldn't make sense for merging them.

I cannot work on this now. But I think that I can do an integration like the 
one that I pushed some month ago (a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4).
Wind River made that changes to videobuf-contig and I tested, fixed and 
pushed.

> >> 	3) what are the usecases for it.
> >> 
> >> Could you please detail it? Without that, one that would be needing to
> >> write a driver will have serious doubts about what would be the right
> >> driver for its usage. Also, please document it at the driver itself.

I don't have a full understand of the board so I don't know exactly why 
dma_alloc_coherent does not work. I focused my development on previous work by 
Wind River. I asked to Wind River (which did all the work on this board) for 
the technical explanation about why coherent doesn't work, but they do not 
know. That's why I made the new allocator: coherent doesn't work and HW 
doesn't support SG.

> I'm not a DMA performance expert. As such, from that comment, it sounded to
> me that replacing dma-config/dma-sg by dma streaming will always give
> "performance optimizations the hardware allow".

me too, I'm not a DMA performance expert. I'm just an user of the DMA API. On 
my hardware simply it works only with that interface, it is not a performance 
problem.

> On a separate but related issue, while doing DMABUF tests with an Exynos4
> hardware, using a s5p sensor, sending data to s5p-tv, I noticed a CPU
> consumption of about 42%, which seems too high. Could it be related to
> not using the DMA streaming API?

As I wrote above, I'm not a DMA performance expert. I skip this

-- 
Federico Vaga
