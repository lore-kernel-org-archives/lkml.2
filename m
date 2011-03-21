Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1CUWza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:55:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63869 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1CUWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ELku8QGwN5nFJq4ikMQUjr3A/6rI+mGTTwSidCfKbwlTKveup40m7JX8hp43HD3BE3
         LHlLgiWUmwbdN+recC1B39Kw9xIpVFBIPZbmrnKIOvGl7CLCIWSDptvSAUfWrqA2mhuZ
         Jq5zjQV7hstqv+0/c6tL6UI22SwGjBXsGepnU=
Message-ID: <4D87D75C.7020704@suse.cz>
Date: Mon, 21 Mar 2011 23:55:24 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <20110228145301.GC10846@dumpdata.com> <4D6BC3AE.903@suse.cz> <4D6BE756.1090800@infradead.org> <4D87D47B.80206@gmail.com>
In-Reply-To: <4D87D47B.80206@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 11:43 PM, Mauro Carvalho Chehab wrote:
> As I got no return, and the patch looked sane, I've reviewed the comment myself,

Aha, I forgot to send it. Sorry.

It looks OK.

> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Mon Feb 28 06:37:02 2011 -0300
> 
>     [media] V4L: videobuf, don't use dma addr as physical
>     
>     mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>     needn't be a physical address in presence of IOMMU, as
>     a hardware IOMMU can (and most likely) will return a bus address where
>     physical != bus address.
>     
>     So ensure we are remapping (remap_pfn_range) the right page in
>     __videobuf_mmap_mapper by using virt_to_phys(mem->vaddr) and not
>     mem->dma_handle.
>     
>     While at it, use PFN_DOWN instead of explicit shift.
>     
>     Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>     Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..19d3e4a 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -300,7 +300,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  
>         vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>         retval = remap_pfn_range(vma, vma->vm_start,
> -                            mem->dma_handle >> PAGE_SHIFT,
> +                          PFN_DOWN(virt_to_phys(mem->vaddr))
>                                  size, vma->vm_page_prot);
>         if (retval) {
>                 dev_err(q->dev, "mmap: remap failed with error %d. ", retval);

thanks,
-- 
js
suse labs
