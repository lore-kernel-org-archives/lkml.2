Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1JMTxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 15:53:03 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:65157 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1JMTxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 15:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <20111013194644.GF18574@ponder.secretlab.ca>
References: <4E937035.8020806@gmx.de> <20111013194644.GF18574@ponder.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 13 Oct 2011 13:52:41 -0600
X-Google-Sender-Auth: xq2kErHgvHQGMximQfI_31QG8qA
Message-ID: <CACxGe6ut+8ERLgQ3BcnqkWKgt2uYNHwk4baP8sjtAXVuJDe7CA@mail.gmail.com>
Subject: Re: [Patch 1/2] gpio-pca953x: fix gpio_base and add verbosity
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 1:46 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Oct 11, 2011 at 12:22:45AM +0200, Hartmut Knaack wrote:
>> gpio_base was set to 0 if no system platform data or open firmware
>> platform data was provided. This led to conflicts, if any other gpiochip
>> with a gpiobase of 0 was instantiated already. Setting it to -1 will
>> automatically use the first one available.
>>
>> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
>> -------------------------------------------------------------
>
> Corrupt patch (linewrap and whitespace damage).  Please check your mailer.

I applied it manually though.

g.

>
>> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
>> index c43b8ff..ae479fd 100644
>> --- a/drivers/gpio/gpio-pca953x.c
>> +++ b/drivers/gpio/gpio-pca953x.c
>> @@ -577,6 +577,7 @@ pca953x_get_alt_pdata(struct i2c_client *client, int
>> *gpio_base, int *invert)
>>  void
>>  pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int
>> *invert)
>>  {
>> +  *gpio_base = -1;
>>  }
>>  #endif
>>
>>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
