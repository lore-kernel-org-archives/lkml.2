Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2BELxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:53:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61153 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2BELxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:53:32 -0500
MIME-Version: 1.0
In-Reply-To: <1326959620-25920-2-git-send-email-b32955@freescale.com>
References: <1326959620-25920-1-git-send-email-b32955@freescale.com>
	<1326959620-25920-2-git-send-email-b32955@freescale.com>
Date: Sun, 5 Feb 2012 19:53:31 +0800
Message-ID: <CAMiH66FoX0m_NPntMRyt6zJoYgxuYnzv6neDggmKxW8nfzKJiA@mail.gmail.com>
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED macro
From: Huang Shijie <shijie8@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: shawn.guo@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        u.kleine-koenig@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does any one have any comments about this patch?

thanks.

On Thu, Jan 19, 2012 at 3:53 PM, Huang Shijie <b32955@freescale.com> wrote:
> Some DMA resource does have the range more then ones.
>
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  include/linux/ioport.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index 9d57a71..9ea5de4 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -134,8 +134,10 @@ struct resource_list {
>  #define DEFINE_RES_IRQ(_irq)                                           \
>        DEFINE_RES_IRQ_NAMED((_irq), NULL)
>
> +#define DEFINE_RES_DMA_SIZE_NAMED(_dma, _size, _name)                  \
> +       DEFINE_RES_NAMED((_dma), (_size), (_name), IORESOURCE_DMA)
>  #define DEFINE_RES_DMA_NAMED(_dma, _name)                              \
> -       DEFINE_RES_NAMED((_dma), 1, (_name), IORESOURCE_DMA)
> +       DEFINE_RES_DMA_SIZE_NAMED((_dma), 1, (_name))
>  #define DEFINE_RES_DMA(_dma)                                           \
>        DEFINE_RES_DMA_NAMED((_dma), NULL)
>
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
