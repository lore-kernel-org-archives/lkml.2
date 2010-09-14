Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0INOqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:46:05 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51582 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0INOp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ge0EcMZiv7I8fyzJbbyhm7XsHiv8Hjfq3RA44gBpvKavg9G9qEWTOc7tkUuSW8gf0E
         EZWBStz4Y6LUcPWokfxj3xw8hNCtPJtE//aXGpDG/jnMAnVmRGHNBz2AClbpc2a/+KnD
         R7xRBfCasIL/Vr74RVACeXKM2dxDSCpqTc/mU=
MIME-Version: 1.0
In-Reply-To: <083DF309106F364B939360100EC290F80AD49D5230@eu1rdcrdc1wx030.exi.nxp.com>
References: <AANLkTikbKwo9=xLWo1qEcc2E5aa2iN2F_KCokJPpnWOk@mail.gmail.com>
	<083DF309106F364B939360100EC290F80AD49D5230@eu1rdcrdc1wx030.exi.nxp.com>
Date: Tue, 14 Sep 2010 16:45:57 +0200
X-Google-Sender-Auth: 6DwyoRiGWqHsBRJPjBs8qkZ4DEg
Message-ID: <AANLkTim4a7eha6Z3pjrZ0kg9VNRcuH52Qs2h4XydsXi4@mail.gmail.com>
Subject: Re: resend: [PATCH] amba_pl022: Setup SPI configuration based on spi->mode
From: Linus Walleij <linus.walleij@stericsson.com>
To: Kevin Wells <kevin.wells@nxp.com>
Cc: Kevin Wells <wellsk40@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rabin.vincent@stericsson.com" <rabin.vincent@stericsson.com>,
        "srinidhi.kasagar@stericsson.com" <srinidhi.kasagar@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "Lukasz.Baj@tieto.com" <Lukasz.Baj@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/13 Kevin Wells <kevin.wells@nxp.com>:

> SSP_CR0_MASK_SPH (SPHA) should use bit 7, not bit 6.
> Should be:
>       SSP_WRITE_BITS(chip->cr0, tmp, SSP_CR0_MASK_SPH, 7);
>
>> +
>>        SSP_WRITE_BITS(chip->cr0, chip_info->clk_freq.scr, SSP_CR0_MASK_SCR,
>> 8);
>>        /* Loopback is available on all versions except PL023 */

That's it!

With this correction it starts working, so
Acked-by/Tested-by/Reviewed-by: Linus Walleij <linus.walleij@stericsson.com>

Please submit the whole patch series with corrections and my tag
so Grant can pick it up, and thanks for doing this because I think
it is a great improvement to the driver!

Yours,
Linus Walleij
