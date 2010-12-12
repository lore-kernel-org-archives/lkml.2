Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0LLTDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:03:09 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:43376 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0LLTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PC0VK4C3OQ/c1hdOmHkOuEASgr2ne4r6cpE3ifCHblgj/3I902aj9wm7t7OHXii+Sw
         VRK/hnL1xdNSVVGLC/YPboiMBCVZCLaSAcHR/giSYGduV5QMlDnBJ43QG3IF7yiXMtdP
         IXpEUkMqG9S/UqM4zf7sY7EGGQhRpuvNbaf08=
Subject: Re: [PATCH v2] ata: pata_at91.c bugfix for high master clock
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        geomatsi@gmail.com, nicolas.ferre@atmel.com, linux@maxim.org.za,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        christian.glindkamp@taskit.de, ryan@bluewatersys.com,
        pgsellmann@portner-elektronik.at
In-Reply-To: <4D04D2E2.20100@ru.mvista.com>
References: <1292099846-24528-1-git-send-email-plyatov@gmail.com>
	 <4D04D2E2.20100@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 22:02:59 +0300
Message-ID: <1292180579.8737.12.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sergei,

> Hello.
> 
> On 11-12-2010 23:37, Igor Plyatov wrote:
> 
> > The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> > and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> > lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
> > does not detect ATA device.
> 
> > Signed-off-by: Igor Plyatov<plyatov@gmail.com>
> [...]

Please use more descriptive comments, because it is not clear what you
mean here. Maybe here you just cut a text...
It is so strange to cut such small amount of text and I does not have
any idea why here is "[...]" exists.

> > diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> > index 0da0dcc..a462405 100644
> > --- a/drivers/ata/pata_at91.c
> > +++ b/drivers/ata/pata_at91.c
> [...]

The same as above. Nobody are able to read you mind on the distance :-)

> > @@ -50,7 +52,7 @@ struct at91_ide_info {
> >   };
> >
> >   static const struct ata_timing initial_timing =
> > -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> > +	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 0, 600, 0};
> 
>     BTW, you haven't described this in the changelog...

Here is just a typo fixed for the ata_timing structure. This typo does
not have influence on the driver operation, but I do not like to leave
such a negligible problem as it is.

> WBR, Sergei

Best regards!
--
Igor Plyatov

