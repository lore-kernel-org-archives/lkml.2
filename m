Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0GWNvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:51:50 -0400
Received: from fep20.mx.upcmail.net ([62.179.121.40]:42565 "EHLO
	fep20.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0GWNvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:51:49 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C499E6F.8030507@odi.ch>
Date: Fri, 23 Jul 2010 15:51:43 +0200
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100703 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: BUG at arch/x86/mm/physaddr.c:5
References: <4C3D5F3F.7070901@odi.ch> <AANLkTimn7Z3LqhLOt4_6ggFgjdzIZQPd_CznOIW-6D1N@mail.gmail.com>
In-Reply-To: <AANLkTimn7Z3LqhLOt4_6ggFgjdzIZQPd_CznOIW-6D1N@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=/bZgxt9lcTTiCogXEfKVRpwqFqbGXHB0knonYiER/Vo= c=1 sm=0 a=ryRDYCshSKMA:10 a=IkcTkHD0fZMA:10 a=t3Ybcp_dDZgqIBLyh2oA:9 a=tIdpedVu8NxawZvd2TwVDC4RFXgA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2010 10:04, Jike Song wrote:
> Seems to be a logical error?  Does the following patch remove your Oops?

Looking at the init code I agree. Yes, the patch fixes the OOPS. I am sure
because the OOPS occurred at every boot and now it's gone.

Thanks!

Ortwin

> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c
> b/drivers/net/wireless/ath/ath9k/recv.c
> index ca6065b..e3e5291 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -844,9 +844,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  	int dma_type;
> 
>  	if (edma)
> -		dma_type = DMA_FROM_DEVICE;
> -	else
>  		dma_type = DMA_BIDIRECTIONAL;
> +	else
> +		dma_type = DMA_FROM_DEVICE;
> 
>  	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
>  	spin_lock_bh(&sc->rx.rxbuflock);
> 
