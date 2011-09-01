Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab1IACcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 22:32:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53793 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab1IACco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 22:32:44 -0400
Date: Wed, 31 Aug 2011 21:59:13 -0500
From: Josh Cartwright <joshc@linux.com>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 1/3] add dma_coherent_write_sync to DMA API
Message-ID: <20110901025913.GA5460@kryptos.austin.rr.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
 <1314826214-22428-2-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314826214-22428-2-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 05:30:12PM -0400, Mark Salter wrote:
> On ARMv6/7 DMA-coherent memory is bufferable which means that CPU writes to
> coherent memory may still be held in a write buffer for a significant amount
> of time. This is largely mitigated by having the MMIO write functions force
> a write buffer flush before doing the actual write to the MMIO register. This
> forces out previous CPU writes to coherent memory for drivers which write to
> a register to inform the device that something was written to memory. However,
> this does not mitigate the problem for devices which poll the DMA memory for
> changes written by the CPU. One such case was found by ming.lei@canonical.com
> in the USB EHCI driver. The EHCI host controller relies at least partly on
> polling DMA coherent memory for information from the driver.
> 
> This patch adds a dma_coherent_write_sync() function to the DMA API which
> drivers can use to explicitly force out data which may otherwise be held up
> in a write buffer. It is a no-op unless and architecture provides its own
> version or the function and sets ARCH_HAS_DMA_COHERENT_WRITE_SYNC.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  Documentation/DMA-API-HOWTO.txt |   15 +++++++++++++++
>  Documentation/DMA-API.txt       |   12 ++++++++++++
>  include/linux/dma-mapping.h     |    6 ++++++
>  3 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
> index a0b6250..8c22b8b 100644
> --- a/Documentation/DMA-API-HOWTO.txt
> +++ b/Documentation/DMA-API-HOWTO.txt
> @@ -400,6 +400,21 @@ Make sure you've called dma_pool_free for all memory allocated
>  from a pool before you destroy the pool. This function may not
>  be called in interrupt context.
>  
> +Some architectures which supporting DMA coherent memory may still have write
> +buffering between the CPU and DMA memory. This buffering may delay CPU writes
> +from reaching coherent memory in a timely manner. These delays in turn can
> +lead lead to dramatic performance issues in certain cases. An architecture

'lead lead' -> 'lead'

-- 
                                       joshc
