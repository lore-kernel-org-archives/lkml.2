Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0IIJgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:36:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37805 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0IIJgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:36:10 -0400
Message-ID: <4C88AA27.5070206@mvista.com>
Date: Thu, 09 Sep 2010 13:34:31 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] MIPS: DMA: Add plat_extra_sync_for_cpu()
References: <064bb0722da5d8c271c2bd9fe0a521cc@localhost> <99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
In-Reply-To: <99a0868bdbcfa8785a92b4af4f6d9b99@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-09-2010 3:02, Kevin Cernekee wrote:

> On noncoherent processors with a readahead cache, an extra platform-
> specific invalidation is required during the dma_sync_*_for_cpu()
> operations to keep drivers from seeing stale prefetched data.

> Signed-off-by: Kevin Cernekee<cernekee@gmail.com>
[...]
> diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
> index 17d5794..8192683 100644
> --- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
> +++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
> @@ -52,6 +52,19 @@ static inline void plat_extra_sync_for_device(struct device *dev)
>   	mb();
>   }
>
> +static inline void plat_extra_sync_for_cpu(struct device *dev,
> +	dma_addr_t dma_handle, unsigned long offset, size_t size,
> +	enum dma_data_direction direction)
> +{
> +	return;

    Why not just empty function bodies?

WBR, Sergei
