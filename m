Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1AFL0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:26:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48133 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1AFL0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VpfUSHO4xARty3UWYP0V6vttmGyKOey89h8zgRLNif33uPyMF4oHUbAxEu5gu0YaC4
         pzqh8WIxg9R1kqJQHeMRWcL8eVBpcrUN8rGi589GqzPgme8fMHtzA4sunb8c4INtFIFU
         IO1xPZ4FCE8yDLdeqaPJzya+V0XzNA/iSEOho=
MIME-Version: 1.0
In-Reply-To: <20101223185921.GB20384@angua.secretlab.ca>
References: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com> <20101223185921.GB20384@angua.secretlab.ca>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 6 Jan 2011 12:26:17 +0100
Message-ID: <AANLkTimpTUz_Fizef09urPBR8vP80KU-5yApjzGWFwc0@mail.gmail.com>
Subject: Re: [PATCH 1/2] spi_imx.c: CSPI3 irq is 0 on imx25
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

2010/12/23 Grant Likely <grant.likely@secretlab.ca>:
> On Thu, Dec 23, 2010 at 12:12:09PM +0100, Richard Genoud wrote:
>> On imx25 soc, MX25_INT_CSPI3 is 0
>> (cf arch/arm/plat-mxc/include/mach/mx25.h).
>> So, the test (spi_imx->irq <= 0) returned an error
>> for this platform.
>> This patch corrects this behaviour.
>>
>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>> ---
>>  drivers/spi/spi_imx.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
>> index 55a38e2..793ae99 100644
>> --- a/drivers/spi/spi_imx.c
>> +++ b/drivers/spi/spi_imx.c
>> @@ -847,7 +847,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
>>       }
>>
>>       spi_imx->irq = platform_get_irq(pdev, 0);
>> -     if (spi_imx->irq <= 0) {
>> +     if (spi_imx->irq < 0) {
>
> I *really* don't want to apply this.  The kernel is slowly moving
> toward NO_IRQ == 0 for all architectures.  This patch is a step in the
> wrong direction because it will break with ARM starts using 0 for
> NO_IRQ.
>
> I would accept a change to spi_imx->irq == NO_IRQ however.
>
> g.
>

Actually, the description of the patch is wrong, but not the patch itself.
The test "if (spi_imx->irq <= 0)" is not testing the IRQ value, but
the return value of platform_get_irq().
And platform_get_irq() can return an error (-ENXIO) or the IRQ value it found.
So, as we are testing if platform_get_irq() failed or not, the test
should be "if (spi_imx->irq < 0)"

If you agree with that, I will resend the patch with a good description.

richard.


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
