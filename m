Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1LMVkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:40:36 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41490 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753892Ab1LMVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:40:32 -0500
Message-ID: <1323812431.3837.31.camel@joe2Laptop>
Subject: Re: [PATCH v3 resend2] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS
 driver use gpiolib
From: Joe Perches <joe@perches.com>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>
Date: Tue, 13 Dec 2011 13:40:31 -0800
In-Reply-To: <4EE7C4AD.8090805@solonet.org.ua>
References: <4EE7B41C.5080006@solonet.org.ua>
	 <1323810417.3837.25.camel@joe2Laptop> <4EE7C1C9.8080000@solonet.org.ua>
	 <1323811732.3837.27.camel@joe2Laptop> <4EE7C4AD.8090805@solonet.org.ua>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 23:33 +0200, Denis Kuzmenko wrote:
> On 12/13/2011 11:28 PM, Joe Perches wrote:
> > The LEDF_ACTLOW use is dependent on it being #defined
> > to 1 when using ^.  I think that's unintelligible.
> Sorry, can't understand. Can you please clarify last two sentences?

	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
			    (pd->flags & S3C24XX_LEDF_ACTLOW));

I think this should be:
	s3c2410_gpio_setpin(pd->gpio,
			    !!value ^ !!(pd->flags & S3C24XX_LEDF_ACTLOW));

