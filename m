Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2GWGw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:52:56 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:51992 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab2GWGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbKbQGKGsqnSKB5NgVG+yuBfHSLSS_bYWWJVXe1_tCByA@mail.gmail.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<d0bd829760aba6c8e686f3b864b3831aa6bdcaa1.1341925681.git.cmahapatra@ti.com>
	<CACRpkdbKbQGKGsqnSKB5NgVG+yuBfHSLSS_bYWWJVXe1_tCByA@mail.gmail.com>
Date: Mon, 23 Jul 2012 12:22:52 +0530
Message-ID: <CAF0AtAunEFYy48zjSD0pbQgWKERX+9A-x6nELX3MGcKJwQiLKQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] gpio/pca953x: register the device irq using
 appropriate api's
From: "Mahapatra, Chandrabhanu" <cmahapatra@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 3:41 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jul 10, 2012 at 3:36 PM, Chandrabhanu Mahapatra
> <cmahapatra@ti.com> wrote:
>
>> From: Leed Aguilar <leed.aguilar@ti.com>
>>
>> Here, the implementation of registration of requested IRQs has been corrected
>> with appropiate api's. The gpio number is requested through gpio_request_one()
>> API and conversion of the gpio to irq is done using the gpio_to_irq() API.
>>
>> Change-Id: I964145e2a280d6553ea2c05ea8049810a1983930
>
> Delete that.
>
>> Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
>> Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>
>> ---
>>  drivers/gpio/gpio-pca953x.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
>> index c3ca7d8..27486da 100644
>> --- a/drivers/gpio/gpio-pca953x.c
>> +++ b/drivers/gpio/gpio-pca953x.c
>> @@ -509,7 +509,13 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
>>  #endif
>>                 }
>>
>> -               ret = request_threaded_irq(client->irq,
>> +               ret = gpio_request_one(client->irq, GPIOF_IN, "pca953x");
>
> Not that it's really related to this one patch, but why is a GPIO number named
> "irq" in client->irq??

Sorry, for the late reply. You need not pull this patch. There has
been some slight miss understanding and as it turns out the
gpio_request_one() should actually be done in the board file with the
appropriate gpio number. This gpio number should be converted to irq
in the board file and then finally sent as client->irq to pca953x
driver. Please undo this patch.


-- 
Chandrabhanu Mahapatra
Texas Instruments India Pvt. Ltd.
