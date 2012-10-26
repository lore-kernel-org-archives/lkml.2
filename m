Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2JZI3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:29:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62316 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab2JZI3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:29:10 -0400
Message-ID: <508A49D3.2080303@monstr.eu>
Date: Fri, 26 Oct 2012 10:29:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: shuah.khan@hp.com
CC: kyungmin.park@samsung.com, m.szyprowski@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, microblaze-uclinux@itee.uq.edu.au,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH RFT] microblaze: dma-mapping: support debug_dma_mapping_error
References: <1351207747.6851.15.camel@lorien2>
In-Reply-To: <1351207747.6851.15.camel@lorien2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:29 AM, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>   arch/microblaze/include/asm/dma-mapping.h |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
> index 01d2282..4451c7a 100644
> --- a/arch/microblaze/include/asm/dma-mapping.h
> +++ b/arch/microblaze/include/asm/dma-mapping.h
> @@ -114,6 +114,7 @@ static inline void __dma_sync(unsigned long paddr,
>   static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>   {
>   	struct dma_map_ops *ops = get_dma_ops(dev);

here should be empty line.

> +	debug_dma_mapping_error(dev, dma_addr);
>   	if (ops->mapping_error)
>   		return ops->mapping_error(dev, dma_addr);

Patch looks good to me. I was greping the latest mainline tree and I can't see
reference to debug_dma_mapping_error. Can you tell me where this function
is implemented.
I have also seen that you have sent several similar patches like this.

If you want to add it through any other tree here is my ACK:

Acked-by: Michal Simek <monstr@monstr.eu>

I will definitely keep my eyes on it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
