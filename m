Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2LEMqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:46:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44386 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2LEMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:45:56 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Wed, 05 Dec 2012 13:50:33 +0100
Message-ID: <1685240.Ttn3DTWMJc@harkonnen>
User-Agent: KMail/4.9.3 (Linux/3.6.8-2.fc17.x86_64; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50BE1F06.10308@redhat.com>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <055901cd9a52$5995fcd0$0cc1f670$%szyprowski@samsung.com> <50BE1F06.10308@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 14:04:22 Mauro Carvalho Chehab wrote:
> Em 24-09-2012 09:44, Marek Szyprowski escreveu:
> > Hello,
> > 
> > On Monday, September 24, 2012 12:59 PM Federico Vaga wrote:
> >> The DMA streaming allocator is similar to the DMA contig but it use the
> >> DMA streaming interface (dma_map_single, dma_unmap_single). The
> >> allocator allocates buffers and immediately map the memory for DMA
> >> transfer. For each buffer prepare/finish it does a DMA synchronization.
> 
> Hmm.. the explanation didn't convince me, e. g.:
> 	1) why is it needed;

This allocator is needed because some device (like STA2X11 VIP) cannot work 
with DMA sg or DMA coherent. Some other device (like the one used by Jonathan 
when he proposes vb2-dma-nc allocator) can obtain much better performance with 
DMA streaming than coherent.

> 	2) why vb2-dma-config can't be patched to use dma_map_single
> (eventually using a different vb2_io_modes bit?);

I did not modify vb2-dma-contig because I was thinking that each DMA memory 
allocator should reflect a DMA API.

> 	3) what are the usecases for it.
> 
> Could you please detail it? Without that, one that would be needing to
> write a driver will have serious doubts about what would be the right
> driver for its usage. Also, please document it at the driver itself.

I did not write all this details because the reasons to use vb2-dma-contig, 
vb2-dma-sg or vb2-dma-streaming are the same reasons because someone choose 
SG, coherent or streaming API. This is already documented in the DMA-*.txt 
files, so I did not rewrite it to avoid duplication.

-- 
Federico Vaga
