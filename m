Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab2IMPmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:42:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2IMPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:42:47 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>
Subject: Re: [PATCH 3/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Thu, 13 Sep 2012 17:46:32 +0200
Message-ID: <2107949.TNqhOsq2WF@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.3-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <002e01cd91b9$2110d160$63327420$%szyprowski@samsung.com>
References: <1347544368-30583-1-git-send-email-federico.vaga@gmail.com> <1347544368-30583-3-git-send-email-federico.vaga@gmail.com> <002e01cd91b9$2110d160$63327420$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday, September 13, 2012 3:53 PM Federico Vaga wrote:
> > Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> 
> A few words explaining why this memory handling module is required or
> beneficial will definitely improve the commit :)

ok, I will write some lines

> > +static void *vb2_dma_streaming_cookie(void *buf_priv)
> > +{
> > +	struct vb2_streaming_buf *buf = buf_priv;
> > +
> > +	return (void *)buf->dma_handle;
> > +}
> 
> Please change this function to:
> 
> static void *vb2_dma_streaming_cookie(void *buf_priv)
> {
> 	struct vb2_streaming_buf *buf = buf_priv;
> 	return &buf->dma_handle;
> }
> 
> and add a following static inline to
> include/media/videobuf2-dma-streaming.h:
> 
> static inline dma_addr_t
> vb2_dma_streaming_plane_paddr(struct vb2_buffer *vb, unsigned int
> plane_no) {
>         dma_addr_t *dma_addr = vb2_plane_cookie(vb, plane_no);
>         return *dma_addr;
> }
> 
> Do not use 'cookie' callback directly in the driver, the driver should
> use the above proxy.
> 
> The &buf->dma_handle workaround is required for some possible
> configurations with 64bit dma addresses, see commit 472af2b05bdefc.

ACK.

-- 
Federico Vaga
