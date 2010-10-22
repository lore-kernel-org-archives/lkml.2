Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab0JVTNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55395 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759736Ab0JVTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:30 -0400
X-Sasl-enc: oRYl2a5wp588Fp9b26XB8I8yJFxYOjyB6r9RIOT+psay 1287774809
Message-ID: <4CC1E257.4070704@fastmail.fm>
Date: Fri, 22 Oct 2010 20:13:27 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Florian Fainelli <florian@openwrt.org>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, 600155@bugs.debian.org,
        Jason Heeris <jason.heeris@gmail.com>,
        David Miller <davem@davemloft.net>, spamalot@hispeed.ch,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [11/17] r6040: Fix multicast list iteration when hash filter
 is used
References: <20101022184033.486292826@clark.site>
In-Reply-To: <20101022184033.486292826@clark.site>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/2010 19:39, Greg KH wrote:
>  drivers/net/r6040.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/r6040.c
> +++ b/drivers/net/r6040.c
> @@ -976,6 +976,7 @@ static void r6040_multicast_list(struct
>  		iowrite16(hash_table[3], ioaddr + MAR3);
>  	}
>  	/* Multicast Address 1~4 case */
> +	dmi = dev->mc_list;
>  	for (i = 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
Any reason for the dmi in the above line? As far as I can see it is a
nop.

>  		adrp = (u16 *)dmi->dmi_addr;
>  		iowrite16(adrp[0], ioaddr + MID_1L + 8*i);
> 

