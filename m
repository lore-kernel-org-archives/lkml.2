Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2AJLza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:55:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2AJLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <013701cccf81$7c0cdb90$742692b0$%szyprowski@samsung.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
	<1323871214-25435-5-git-send-email-ming.lei@canonical.com>
	<010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
	<CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
	<015201ccc156$033f73a0$09be5ae0$%szyprowski@samsung.com>
	<CACVXFVNdczv=tu7VG24766myCnGDRWAjkthbdfMwTGzTwFCoBA@mail.gmail.com>
	<015301ccc15f$053e61d0$0fbb2570$%szyprowski@samsung.com>
	<CACVXFVMrRTS7TUtj7bqCWeF4zx11yT6mOq4syOkZv=Ejoo0LMw@mail.gmail.com>
	<013701cccf81$7c0cdb90$742692b0$%szyprowski@samsung.com>
Date: Tue, 10 Jan 2012 19:55:25 +0800
Message-ID: <CACVXFVMUfGCMGReJqoD5ap1QxiDMPEwnd9Sq2FZQRjCRxugEng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/8] media: videobuf2: introduce VIDEOBUF2_PAGE memops
From: Ming Lei <ming.lei@canonical.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Pawel Osciak <p.osciak@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 10, 2012 at 6:20 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:

>> Sorry, could you describe the abuse problem in a bit detail?
>
> Videobuf2 requires memory module handlers to provide vaddr method to provide a pointer in
> kernel virtual address space to video data (buffer content). It is used for example by

Yes, this is what the patch is doing, __get_free_pages just  returns
the kernel virtual
address which will be passed to driver.

> read()/write() io method emulator. Memory allocator/handler should not be specific to any
> particular use case in the device driver. That's the design. Simple.

Most of the patch is copied from videobuf-vmalloc.c, and the
interfaces are totally same
with videobuf-vmalloc.c.

>
> I your case you want to give pointer to struct page from the memory allocator to the

In my case, the pointer to struct page is not required to the driver
at all, so I think you
have misunderstood the patch, don't I?

> driver. The cookie method has been introduced exactly for this purpose. Memory allocator
> also provides a simple inline function to convert generic 'void *' return type from cookie
> method to allocator specific structure/pointer. vb2_dma_contig_plane_dma_addr() and
> vb2_dma_sg_plane_desc() were examples how does passing allocator specific type though the
> cookie method works.

thanks,
--
Ming Lei
