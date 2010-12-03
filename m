Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab0LCXUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:20:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36418 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0LCXUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bXcR7OqAX+KBE/7Y+cLy2tEwGvjckUs0mrpeXdAjes3FYDVJtS1vy1dT82wuxJfJCw
         uPP5NN+OFHbsuPP24d+7kHWzVlFJuDkRGZiLUhW/jtZBphnxHujDOgEasYFf9pWCj1Nn
         9Xyk++s84nmpqe5LEahAM5X9H4FJH1U4ycmG4=
MIME-Version: 1.0
In-Reply-To: <1290510371-23077-2-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
	<1290510371-23077-2-git-send-email-jamie@jamieiles.com>
Date: Fri, 3 Dec 2010 15:20:01 -0800
X-Google-Sender-Auth: aziTMAnU5NLshIhxuzBB9p9vhtA
Message-ID: <AANLkTi=jraL77=ix=y5QF9YVTVZ9XGF6AXKEx5yMJW3i@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine/dw_dmac: don't scan descriptors if no xfers
 in progress
From: Dan Williams <dan.j.williams@intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Jamie Iles <jamie.iles@picochip.com>,
        hskinnemoen@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ copying Haavard's new address ]

On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> Some hardware (picoChip picoXCell in particular) sometimes has
> the block transfer complete bit being set for a channel after the
> whole transfer has completed. If we don't have any transfers in the
> active list then don't bother to scan the descriptors. This often
> happens in normal operation and doesn't require the channel to be
> reset.
>
> Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
> ---
>  drivers/dma/dw_dmac.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index a3991ab..08c51d4 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -291,6 +291,9 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
>                return;
>        }
>
> +        if (list_empty(&dwc->active_list))
> +                return;
> +
>        dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
>
>        list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
> --
> 1.7.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
