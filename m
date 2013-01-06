Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3AFRF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:05:58 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33005 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3AFRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:05:55 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        sylwester Nawrocki <s.nawrocki@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Sun, 06 Jan 2013 18:04:39 +0100
Message-ID: <3892735.vLSnhhCRFi@harkonnen>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <12929800.xFTBAueAE0@harkonnen>
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <1399400.izKZgEHXnP@harkonnen> <12929800.xFTBAueAE0@harkonnen>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have more information about DMA on the board that I'm using; probably, I
> can make dma-contig work with my device.

Ok, the driver STA2X11 now works with a patched dma-contig allocator. So, my 
streaming allocator it is not mandatory. 

I based my work on the previous work made by Windriver, but now I understand 
the DMA problem and the solution easy.
I investigated (asked to Alessandro Rubini who worked on this board) about 
this DMA issue. The problem is that on the sta2x11 architecture only the first 
512MB are available through the PCI bus, but the allocator can allocate memory 
for DMA above this limit. By using GFP_DMA flags the allocation take place 
under the 16MB so it works.

If you think that the streaming allocator can be useful for someone else (who 
has performance problem with uncached DMA like Jonathan when he did dma-nc 
allocator), I can resend the patch.
I cannot do performance test at the moment because I don't have the time, so I 
cannot personally justify the presence of a new allocator. I think that I will 
do some performance test with this driver; if I will find that dma-streaming 
works better I will propose it again.

I will propose V4 patches soon.

-- 
Federico Vaga
