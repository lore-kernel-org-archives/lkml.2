Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0KEJ3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 05:29:47 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:62381 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab0KEJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 05:29:45 -0400
Message-ID: <4CD3CE7C.4040407@shipmail.org>
Date: Fri, 05 Nov 2010 10:29:32 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 10/49] drivers/gpu: Use vzalloc
References: <alpine.DEB.2.00.1011031108260.11625@router.home> <82d9fb31aa5f4e28acfda333331a30ef382d27b9.1288925424.git.joe@perches.com>
In-Reply-To: <82d9fb31aa5f4e28acfda333331a30ef382d27b9.1288925424.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 04:07 AM, Joe Perches wrote:
> Signed-off-by: Joe Perches<joe@perches.com>
>    
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

> ---
>   drivers/gpu/drm/via/via_dmablit.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
> index 9b5b4d9..3e038a3 100644
> --- a/drivers/gpu/drm/via/via_dmablit.c
> +++ b/drivers/gpu/drm/via/via_dmablit.c
> @@ -235,9 +235,9 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_via_dmablit_t *xfer)
>   	vsg->num_pages = VIA_PFN(xfer->mem_addr + (xfer->num_lines * xfer->mem_stride - 1)) -
>   		first_pfn + 1;
>
> -	if (NULL == (vsg->pages = vmalloc(sizeof(struct page *) * vsg->num_pages)))
> +	vsg->pages = vzalloc(sizeof(struct page *) * vsg->num_pages);
> +	if (NULL == vsg->pages)
>   		return -ENOMEM;
> -	memset(vsg->pages, 0, sizeof(struct page *) * vsg->num_pages);
>   	down_read(&current->mm->mmap_sem);
>   	ret = get_user_pages(current, current->mm,
>   			     (unsigned long)xfer->mem_addr,
>    

