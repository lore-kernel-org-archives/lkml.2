Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1KOXEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:04:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35597 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab1KOXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:04:30 -0500
Message-ID: <4EC2F035.3060705@solonet.org.ua>
Date: Wed, 16 Nov 2011 01:05:25 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: add flags to export GPIOs when requesting
References: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1321397074-6526-1-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,
On 11/16/2011 12:44 AM, Wolfram Sang wrote:
> Introduce new flags to automatically export GPIOs when using the convenience
> functions gpio_request_one() or gpio_request_array(). This eases support for
> custom boards where lots of GPIOs need to be exported for customer
> applications.

Adding GPIO maintainer Grant Likely to CC.

> +#define GPIOF_EXPORT		(1 << 2)
> +#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
> +#define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
> +#define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE)

Maybe, it's better to write like this:

#define GPIOF_EXPORT			(1 << 2)
#define GPIOF_EXPORT_DIR_CHANGEABLE	(3 << 2)

So you don't need additional defines (GPIOF_EXPORT_DIR_FIXED and
GPIOF_EXPORT_DIR_CHANGEABLE). This will not brake your logic and improve
readability IMHO.

-- 
Best regards, Denis Kuzmenko.
