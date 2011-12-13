Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1LMWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:16:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:49838 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754846Ab1LMWQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:16:53 -0500
Message-ID: <1323814611.3837.40.camel@joe2Laptop>
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
Date: Tue, 13 Dec 2011 14:16:51 -0800
In-Reply-To: <4EE7CC34.8000209@solonet.org.ua>
References: <4EE7B41C.5080006@solonet.org.ua>
	 <1323810417.3837.25.camel@joe2Laptop> <4EE7C1C9.8080000@solonet.org.ua>
	 <1323811732.3837.27.camel@joe2Laptop> <4EE7C4AD.8090805@solonet.org.ua>
	 <1323812431.3837.31.camel@joe2Laptop> <4EE7CC34.8000209@solonet.org.ua>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 00:05 +0200, Denis Kuzmenko wrote:
> On 12/13/2011 11:40 PM, Joe Perches wrote:
> > On Tue, 2011-12-13 at 23:33 +0200, Denis Kuzmenko wrote:
> >> On 12/13/2011 11:28 PM, Joe Perches wrote:
> >>> The LEDF_ACTLOW use is dependent on it being #defined
> >>> to 1 when using ^.  I think that's unintelligible.
> >> Sorry, can't understand. Can you please clarify last two sentences?
> > 	s3c2410_gpio_setpin(pd->gpio, (value ? 1 : 0) ^
> > 			    (pd->flags & S3C24XX_LEDF_ACTLOW));
> > I think this should be:
> > 	s3c2410_gpio_setpin(pd->gpio,
> > 			    !!value ^ !!(pd->flags & S3C24XX_LEDF_ACTLOW));
> So you've found a BUG.

It's not really a bug, it's more lack of consistency
style defect.  It's also an example of why I prefer
consistent style to equivalent but different styles.

> As I understand my code will behave wrong if
> S3C24XX_LEDF_ACTLOW value will be changed.

> Thank you, I'll make a new version.

cheers, Joe

