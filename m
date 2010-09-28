Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab0I1Svv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:51:51 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47337 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab0I1Svu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VT40lcE8A5daPnW4KsqKDHI+Y0m4oaI+TuxVQV8z+fVgYvwkiaVMf8sBbPxJIiheJK
         X+QaN6g9/WIohw8Emt4jj5ObUeULcmHdnPshHq7ymi744PAcCmmlez6Zbtvj7B0ulhcX
         k5s5r7LdXnD/y1nqGGwmIfJXzSpsFYxNglPoI=
Message-ID: <4CA23941.2050803@pobox.com>
Date: Tue, 28 Sep 2010 14:51:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] de2104x: disable media debug messages by default
References: <201009282018.57547.linux@rainbow-software.org>
In-Reply-To: <201009282018.57547.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 02:18 PM, Ondrej Zary wrote:
> Print media debug messages only when HW debug is enabled.
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>
> --- linux-2.6.36-rc3-/drivers/net/tulip/de2104x.c	2010-09-28 19:50:51.000000000 +0200
> +++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c	2010-09-28 20:05:34.000000000 +0200
> @@ -948,8 +948,9 @@ static void de_set_media (struct de_priv
>   	else
>   		macmode&= ~FullDuplex;
>
> -	if (netif_msg_link(de)) {
> +	if (netif_msg_link(de))
>   		dev_info(&de->dev->dev, "set link %s\n", media_name[media]);
> +	if (netif_msg_hw(de)) {
>   		dev_info(&de->dev->dev, "mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n",
>   			 dr32(MacMode), dr32(SIAStatus),
>   			 dr32(CSR13), dr32(CSR14), dr32(CSR15));

Acked-by: Jeff Garzik <jgarzik@redhat.com>


