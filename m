Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1DTMiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:38:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1DTMiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VxOdNGrgB6P0z7An+zZhogspuOM3sQj5mX8sZIWsssRlZmXJ0RjO0WvyYQGTBIV7FL
         0ZIls+RgQ+gqWLRXMHPxGtGeD445vDAneZ9qDjgtFfUOYclNzV6Cekhgt1P8U034nQyc
         hoUC3IQCq0dIZRZkQWFn+pWCHZwnLBABNqe1M=
MIME-Version: 1.0
In-Reply-To: <D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<D3BCC8A3-7570-49F2-838C-A2B1899B0519@niasdigital.com>
Date: Wed, 20 Apr 2011 14:38:01 +0200
X-Google-Sender-Auth: DfoNWPVqDcGRQ2wukrNitlEI5f4
Message-ID: <BANLkTi=M3FxU6vv_aq1rLTmXQCGps=hC=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Nizette <bn@niasdigital.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Ben Nizette <bn@niasdigital.com>:
> On 19/04/2011, at 6:38 PM, Alan Cox wrote:
>> Leaving aside the current input/output and on/off bits I would go for
>> being able to do
>>
>>       gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
>>       gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);
>
> Yeah I'm all for that so long as the capability constants are defined by the gpio
> provider, eg <linux/gpio/mygpioexpander.h>.  There's no way gpiolib should be
> keeping a big ole list of every possible config option for every gpio provider.

OK I buy that. I will refactor this solution to some opaque call instead
and start from there.

> Well, maybe gpiolib can know about the options (eg GPIO_BIAS) so long
> as it doesn't have to enumerate every possible value.

I will drop that even, one parameter is better than two if one of them
is custom nevertheless. What difference does it make..

Yours,
Linus Walleij
