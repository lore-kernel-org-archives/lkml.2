Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1GZVyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:54:40 -0400
Received: from c60.cesmail.net ([216.154.195.49]:39928 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab1GZVyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:54:39 -0400
Message-ID: <4E2F379D.9080108@gnu.org>
Date: Tue, 26 Jul 2011 17:54:37 -0400
From: Pavel Roskin <proski@gnu.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hostap_cs: add ID for LG cards
References: <201107262314.03422.linux@rainbow-software.org>
In-Reply-To: <201107262314.03422.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 05:14 PM, Ondrej Zary wrote:
> Add IDs for LG PCMCIA cards.
> This allows LG LW1100P PCI card (with integrated CardBus bridge) to work
> (tested with rev 3.0) and probably also LW1100N (PCMCIA).
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>

Acked-by: Pavel Roskin <proski@gnu.org>

I googled for the card name and found indications that the card uses 
Intersil firmware and thus supportable by Hostap.

The problem was reported in year 2003, first in June:
http://osdir.com/ml/linux.drivers.hostap/2003-06/msg00159.html

And then in November:
http://osdir.com/ml/linux.linux-wlan.user/2003-11/msg00039.html

It's quite disappointing that we are fixing this more than 8 years after 
the first report, when the cards in question have become rare and 
obsolete.  But it's still better than nothing.

> --- linux-2.6.39-rc2-orig/drivers/net/wireless/hostap/hostap_cs.c	2011-04-06 03:30:43.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/net/wireless/hostap/hostap_cs.c	2011-07-26 22:17:03.000000000 +0200
> @@ -648,6 +648,8 @@ static struct pcmcia_device_id hostap_cs
>   					 0x74c5e40d),
>   	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "Intersil",
>   					 0x4b801a17),
> +	PCMCIA_DEVICE_MANF_CARD_PROD_ID1(0x0156, 0x0002, "LG",
> +					 0xb474d43a),

What is the "pccardctl ident" output on your card?

I think we may want to introduce PCMCIA_DEVICE_MANF_CARD_PROD_ID3 and match

PCMCIA_DEVICE_MANF_CARD_PROD_ID3(0x0156, 0x0002, "Version 1.02", xxx)

Maybe some other card would be supported too?  I doubt there are any 
Agere or Symbol cards with "Version 1.02" in the third text ID.

-- 
Regards,
Pavel Roskin
