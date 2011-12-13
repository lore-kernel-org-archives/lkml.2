Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1LMWHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:07:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1LMWHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:07:18 -0500
Message-ID: <4EE7CC34.8000209@solonet.org.ua>
Date: Wed, 14 Dec 2011 00:05:40 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v3 resend2] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS
 driver use gpiolib
References: <4EE7B41C.5080006@solonet.org.ua>	 <1323810417.3837.25.camel@joe2Laptop> <4EE7C1C9.8080000@solonet.org.ua>	 <1323811732.3837.27.camel@joe2Laptop> <4EE7C4AD.8090805@solonet.org.ua> <1323812431.3837.31.camel@joe2Laptop>
In-Reply-To: <1323812431.3837.31.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 11:40 PM, Joe Perches wrote:
> On Tue, 2011-12-13 at 23:33 +0200, Denis Kuzmenko wrote:
>> On 12/13/2011 11:28 PM, Joe Perches wrote:
>>> The LEDF_ACTLOW use is dependent on it being #defined
>>> to 1 when using ^.  I think that's unintelligible.
>> Sorry, can't understand. Can you please clarify last two sentences?
> 
> 	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
> 			    (pd->flags & S3C24XX_LEDF_ACTLOW));
> 
> I think this should be:
> 	s3c2410_gpio_setpin(pd->gpio,
> 			    !!value ^ !!(pd->flags & S3C24XX_LEDF_ACTLOW));
> 

So you've found a BUG. As I understand my code will behave wrong if
S3C24XX_LEDF_ACTLOW value will be changed.
Thank you, I'll make a new version.

-- 
Best regards, Denis Kuzmenko.
