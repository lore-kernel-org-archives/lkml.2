Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab1GLERX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 00:17:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43196 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1GLERV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 00:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <1310310203-12288-1-git-send-email-sundaram@ti.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
Date: Tue, 12 Jul 2011 09:47:19 +0530
Message-ID: <CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Sundaram Raju <sundaram@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, dan.j.williams@intel.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 8:33 PM, Sundaram Raju <sundaram@ti.com> wrote:
> Added new dma_ctrl_cmd TI_DMA_STRIDE_CONFIG to pass the TI DMA
> controller specific configurations on how a buffer must be walked
> through and how data is picked for transfer based on a specified
> pattern over the channel.
>
> The configuration passed is specific to the TI DMA controller used.
>
> Signed-off-by: Sundaram Raju <sundaram@ti.com>
> ---
>  include/linux/dmaengine.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> index eee7add..51dadc4 100644
> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -123,6 +123,10 @@ enum dma_ctrl_flags {
>  * command.
>  * @FSLDMA_EXTERNAL_START: this command will put the Freescale DMA controller
>  * into external start mode.
> + * @TI_DMA_STRIDE_CONFIG: this command is only implemented by TI DMA
> + * controllers that need to pass special configuration on how to walk through
> + * the buffer to pick up data in a specified pattern to be transferred in
> + * the channel.
>  */
>  enum dma_ctrl_cmd {
>        DMA_TERMINATE_ALL,
> @@ -130,6 +134,7 @@ enum dma_ctrl_cmd {
>        DMA_RESUME,
>        DMA_SLAVE_CONFIG,
>        FSLDMA_EXTERNAL_START,
> +       TI_DMA_STRIDE_CONFIG,
>  };
IMHO this isn't very correct.

1) Striding, in one form or other, is supported by other DMACs as well.
   The number will only increase in future.
   Are we to add  <VENDOR>_DMA_STRIDE_CONFIG for each case ?

2) As Dan noted, client drivers are going to have ifdef hackery in
order to be common
 to other SoCs.

3) TI may not have just one DMAC IP used in all the SoCs. So if you want
  vendor specific defines anyway, please atleast also add DMAC version to it.
  Something like
>        DMA_SLAVE_CONFIG,
>        FSLDMA_EXTERNAL_START,
> +       TI_DMA_v1_STRIDE_CONFIG,
