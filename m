Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2K0HcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:32:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60656 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab2K0HcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WdmxCmkvLv5SP=2vgMdgb7MtCDAXtgv64bLY4tfsmb8w@mail.gmail.com>
References: <1353995979-28792-1-git-send-email-prabhakar.lad@ti.com> <CAH9JG2WdmxCmkvLv5SP=2vgMdgb7MtCDAXtgv64bLY4tfsmb8w@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 27 Nov 2012 13:01:38 +0530
Message-ID: <CA+V-a8tm+bhnXNEtKHsgQWVUJy3m4k1DNzFvOQhuMk42FnqyAw@mail.gmail.com>
Subject: Re: [PATCH] media: fix a typo CONFIG_HAVE_GENERIC_DMA_COHERENT in videobuf2-dma-contig.c
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 27, 2012 at 12:47 PM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> Hi,
>
> Does it right to use CONFIG_HAVE_GENERIC_DMA_COHERENT?
> it defined at init/Kconfig
>
> config HAVE_GENERIC_DMA_COHERENT
>         bool
>         default n
> and use at C file or header file as CONFIG_ prefix?
> e.g., include/asm-generic/dma-coherent.h:#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
>
My Bad right fix should have been this:

------------------x-----------------------
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 5729450..083b065 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -226,7 +226,7 @@ static int vb2_dc_mmap(void *buf_priv, struct
vm_area_struct *vma)
 /*         DMABUF ops for exporters          */
 /*********************************************/

-#ifdef HAVE_GENERIC_DMA_COHERENT
+#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT

 struct vb2_dc_attachment {
        struct sg_table sgt;

Regards,
--Prabhakar

> Thank you,
> Kyungmin Park
>
> On 11/27/12, Prabhakar Lad <prabhakar.csengg@gmail.com> wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> from commit 93049b9368a2e257ace66252ab2cc066f3399cad, which adds
>> a check HAVE_GENERIC_DMA_COHERENT for dma ops, the check was wrongly
>> made it should have been HAVE_GENERIC_DMA_COHERENT but it was
>> CONFIG_HAVE_GENERIC_DMA_COHERENT.
>> This patch fixes the typo, which was causing following build error:
>>
>> videobuf2-dma-contig.c:743: error: 'vb2_dc_get_dmabuf' undeclared here (not
>> in a function)
>> make[3]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 5729450..dfea692 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -739,7 +739,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx,
>> struct dma_buf *dbuf,
>>  const struct vb2_mem_ops vb2_dma_contig_memops = {
>>       .alloc          = vb2_dc_alloc,
>>       .put            = vb2_dc_put,
>> -#ifdef CONFIG_HAVE_GENERIC_DMA_COHERENT
>> +#ifdef HAVE_GENERIC_DMA_COHERENT
>>       .get_dmabuf     = vb2_dc_get_dmabuf,
>>  #endif
>>       .cookie         = vb2_dc_cookie,
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
