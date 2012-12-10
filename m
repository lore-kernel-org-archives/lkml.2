Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2LJOvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:51:08 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:51282 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2LJOvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:51:06 -0500
X-Greylist: delayed 774 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 09:51:06 EST
MIME-Version: 1.0
In-Reply-To: <1355150404-6732-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355150404-6732-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 10 Dec 2012 20:21:05 +0530
Message-ID: <CAKohpomWU9CBipN9PW4GMcVugTKCy+u-=T6qapCQ6Ru40ctwkg@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] dw_dmac: backlink to dw_dma in dw_dma_chan is superfluous
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 20:10, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The same information could be exctracted from the struct dma_chan.
> The patch introduces helper function dwc_get_data_width() as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c      |   19 ++++++++++++-------
>  drivers/dma/dw_dmac_regs.h |    3 ---
>  2 files changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index fdae96f..427d35b 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -73,6 +73,14 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
>   */
>  #define NR_DESCS_PER_CHANNEL   64
>
> +static inline unsigned int dwc_get_data_width(struct dma_chan *chan, bool d)
> +{
> +       struct dw_dma *dw = to_dw_dma(chan->device);
> +       struct dw_dma_slave *dws = chan->private;
> +
> +       return dw->data_width[d ? dwc_get_dms(dws) : dwc_get_sms(dws)];
> +}

I am so sorry to ask for V3 for this patch, but i didn't like the bool d at all.
Logically the variable name is not good enough in describing its purpose.

What i would have done here is:
#define SRC_MASTER 0
#define DST_MASTER 1

And used them here. :)

Rest is fine.
