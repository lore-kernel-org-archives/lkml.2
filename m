Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3AHKKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:10:47 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35498 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3AHKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:10:44 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Pawel Osciak <pawel@osciak.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v4 1/3] videobuf2-dma-contig: user can specify GFP flags
Date: Tue, 08 Jan 2013 11:15:28 +0100
Message-ID: <1609748.zs7bdcvuG8@harkonnen>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <50EBC26E.5090803@samsung.com>
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com> <50EBC26E.5090803@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -165,7 +161,8 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> > long size)> 
> >   	/* align image size to PAGE_SIZE */
> >   	size = PAGE_ALIGN(size);
> > 
> > -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, 
GFP_KERNEL);
> > +	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> > +									
GFP_KERNEL | conf->mem_flags);
> 
> I think we can add GFP_DMA flag unconditionally to the vb2_dc_contig
> allocator.
> It won't hurt existing clients as most of nowadays platforms doesn't
> have DMA
> zone (GFP_DMA is ignored in such case), but it should fix the issues
> with some
> older and non-standard systems.

I did not set GFP_DMA fixed in the allocator because I do not want to brake 
something in the future. On x86 platform GFP_DMA allocates under 16MB and this 
limit can be too strict. When many other drivers use GFP_DMA we can saturate 
this tiny zone.
As you said, this fix the issue with _older_ and _non-standard_ (like sta2x11) 
systems. But this fix has effect on every other standard and new systems. 
That's why I preferred to set the flag optionally.

-- 
Federico Vaga
