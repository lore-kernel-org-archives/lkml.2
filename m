Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1AZRLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:11:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54094 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZRLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=PQrg/aG/VcEXqlYm1mQn6oQrWhIpaGv/3XDVkvPWz8DkpPMynkEOomkf/p9hrUx+pO
         hhAlHbkm7EMwmP8anhYDBx8Pg9QQQJp/D5nx+hCjqZa3Pz3V/1PrJS4TQCAAZgtW6Jcd
         EmXBdHq+d8lPGGuJNnXq8MDrJCOFQCc4XOTag=
MIME-Version: 1.0
In-Reply-To: <20110122010830.GK23596@mail.wantstofly.org>
References: <20110122010830.GK23596@mail.wantstofly.org>
From: Ian Molton <ian@mnementh.co.uk>
Date: Wed, 26 Jan 2011 17:11:16 +0000
X-Google-Sender-Auth: _ps7bxsqMgbaqiHnkAW-Ejc1lZk
Message-ID: <AANLkTikU=nMVrBKTtTFuR7_JKF9ULj+myq3zpYsfFbXA@mail.gmail.com>
Subject: Re: [PATCH] mfd: Fix ASIC3 build with GENERIC_HARDIRQS_NO_DEPRECATED
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Ian Molton <ian@mnementh.co.uk>

:)

-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/



On 22 January 2011 01:08, Lennert Buytenhek <buytenh@wantstofly.org> wrote:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
>
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index 6a1f940..c45e630 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -143,9 +143,9 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
>        unsigned long flags;
>        struct asic3 *asic;
>
> -       desc->chip->ack(irq);
> +       desc->irq_data.chip->irq_ack(&desc->irq_data);
>
> -       asic = desc->handler_data;
> +       asic = get_irq_data(irq);
>
>        for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
>                u32 status;
> --
>
