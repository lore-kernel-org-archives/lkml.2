Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0I3Jqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:46:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65175 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab0I3Jqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pGPgB6h8MsNOqACeBxVyiKSBRhn71LHwj3d7lGXKRoCUPs80LjHsZzdVsaIU4hhIrW
         aw2I600hkPU2nBKqvDmXUE9T/sX0vzOPB3GDIZls7jJxJBrc6K+rejynkSue+8aD7nqD
         PhhtQhR033eo4AYWuTNpr1v0KQABtxiI+Hqww=
MIME-Version: 1.0
In-Reply-To: <201009282018.57547.linux@rainbow-software.org>
References: <201009282018.57547.linux@rainbow-software.org>
Date: Thu, 30 Sep 2010 11:46:49 +0200
Message-ID: <AANLkTi=rzhb2bNpHe=Wu=57t5FAiYWhynQNLOnQxDAJm@mail.gmail.com>
Subject: Re: [PATCH] de2104x: disable media debug messages by default
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/28 Ondrej Zary <linux@rainbow-software.org>:
> Print media debug messages only when HW debug is enabled.
>
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> --- linux-2.6.36-rc3-/drivers/net/tulip/de2104x.c       2010-09-28 19:50:51.000000000 +0200
> +++ linux-2.6.36-rc3/drivers/net/tulip/de2104x.c        2010-09-28 20:05:34.000000000 +0200
> @@ -948,8 +948,9 @@ static void de_set_media (struct de_priv
>        else
>                macmode &= ~FullDuplex;
>
> -       if (netif_msg_link(de)) {
> +       if (netif_msg_link(de))
>                dev_info(&de->dev->dev, "set link %s\n", media_name[media]);

You can use netif_info(de, link, de->dev, ...) instead and get 'ethX:
' prefix for free.

> +       if (netif_msg_hw(de)) {
>                dev_info(&de->dev->dev, "mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n",
>                         dr32(MacMode), dr32(SIAStatus),
>                         dr32(CSR13), dr32(CSR14), dr32(CSR15));

Same here.

Best Regards,
Micha³ Miros³aw
