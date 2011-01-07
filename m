Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1AGQmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:42:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52536 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1AGQmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:42:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JP7C0CSDNpn1cl6oaCfd+NBYOuWh1DkKew9Y6WvgtiMrW9CLw1ZA8Z0WatDf4F9CN6
         DExtqgbwC2DKLCwSOp6izuQZOdHini5WFeaNWoyPt5g2juKmkWQ0LWjiId+DbzE1So8U
         M9AKEVDeMK0k9ruBKk6MIvDd7INg77VGQU9uY=
MIME-Version: 1.0
In-Reply-To: <AANLkTin0eXCpLD1B0+zABqYcWxzG8+kM1cpRyD+Af_2n@mail.gmail.com>
References: <AANLkTimpTUz_Fizef09urPBR8vP80KU-5yApjzGWFwc0@mail.gmail.com>
 <1294410361-9092-1-git-send-email-richard.genoud@gmail.com> <AANLkTin0eXCpLD1B0+zABqYcWxzG8+kM1cpRyD+Af_2n@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 7 Jan 2011 17:41:53 +0100
Message-ID: <AANLkTi=SCQYOTSQGpRnje-+=h5AZTtuaEOT6LO4VQA8T@mail.gmail.com>
Subject: Re: [PATCH] spi_imx.c: correct the test on platform_get_irq() return value
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net,
        David Brownell <dbrownell@users.sourceforge.net>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/7 Grant Likely <grant.likely@secretlab.ca>:
> On Fri, Jan 7, 2011 at 7:26 AM, Richard Genoud <richard.genoud@gmail.com> wrote:
>> The test "if (spi_imx->irq <= 0)" is not testing the IRQ value, but the return value of platform_get_irq().
>> As platform_get_irq() can return an error (-ENXIO) or the IRQ value it found, the test should be "if (spi_imx->irq < 0)"
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>
> For the majority of architectures in Linux, 0 is not a valid IRQ for
> devices.  Unless there is an actual imx platform that currently
> assigns linux irq 0 to the spi controller then I'd rather not apply
> this change.
actually, there is the imx25 platform:
in arch/arm/plat-mxc/include/mach/mx25.h
line 61 :
#define MX25_INT_CSPI3          0
this is the interrupt assigned for CSPI3.

I doubled check with the imx25 release manual chapter 3.1 (page 51):
http://cache.freescale.com/files/dsp/doc/ref_manual/IMX25RM.pdf
And I made some spi test on the imx25 3stack PDK, the CSPI3 is working
with irq 0.

richard.
