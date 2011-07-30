Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1G3NrU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 09:47:20 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:2350 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941Ab1G3NrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 09:47:10 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 09:47:09 EDT
Message-ID: <4E340A0C.5040604@gmail.com>
Date: Sat, 30 Jul 2011 15:41:32 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com>
In-Reply-To: <20110730113255.GB2847@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2011 13:41:32.0802 (UTC) FILETIME=[64C0EE20:01CC4EBE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/11 13:32, Stanislaw Gruszka wrote:
> We should clear skb->data not skb itself. Bug was introduced by:
> commit 0b8004aa12d13ec750d102ba4082a95f0107c649 "rt2x00: Properly
> reserve room for descriptors in skbs".
> 
> Cc: stable@kernel.org # 2.6.36+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Ouch. Good catch. Let me go find a brown paper bag now :-(

Not sure if this is the source of Justin's problems, though.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 75d2c6c..f94d669 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -703,8 +703,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>  	/*
>  	 * Add space for the TXWI in front of the skb.
>  	 */
> -	skb_push(entry->skb, TXWI_DESC_SIZE);
> -	memset(entry->skb, 0, TXWI_DESC_SIZE);
> +	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
>  
>  	/*
>  	 * Register descriptor details in skb frame descriptor.


-- 
---
Gertjan
