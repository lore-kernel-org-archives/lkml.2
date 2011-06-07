Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1FGNq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:46:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60142 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1FGNqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RzSd9Q9culJjazj6bvHRWpkGaViDZsTrvGL5/ttSrTmZTdaSMTCV7Gw7gWEa0CUEgk
         2i2FU80jn9lzshofCaZSOmGa/N3s3Gpzk4KLz15Vd4G1KtFgOvVgnJQ7QIEbeHhsF5Vj
         cZz62YuewdvCXtPZntcvOApNi4qRMHON+Juog=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=qjFtWeavDZbzY5bQR5vdnwAfnqw@mail.gmail.com>
References: <1302808850-7608-1-git-send-email-linus.walleij@linaro.org>
	<BANLkTi=qjFtWeavDZbzY5bQR5vdnwAfnqw@mail.gmail.com>
Date: Tue, 7 Jun 2011 15:46:52 +0200
X-Google-Sender-Auth: 2xkcMKsmdDY_THEgnyhhoLwgi3A
Message-ID: <BANLkTikUVGBRvCAPDZTpzTfpHHTM8Y+iTA@mail.gmail.com>
Subject: Re: [PATCH] gpio: expose gpio_to_chip()
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/14 Grant Likely <grant.likely@secretlab.ca>:
> On Thu, Apr 14, 2011 at 1:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> This makes the gpio_to_chip() function available to drivers. The
>> usecase is when you want to add a few chip-specific operations
>> apart from the ones exposed in struct gpio_chip.
>
> Similar to interrupt handling, it probably isn't a good idea to expose
> the gpio_chip directly.  Go ahead and add the ops you need and see
> what it looks like.

So have we come to a conclusion about what mechanism we shall use
for the custom GPIO ops? I need this to migrate the U300 and Nomadik
GPIO drivers to struct gpio_chip.

I suspect this patch will apply right off if you prefer this solution with
specific functions for specific stuff above the generic scheme of extending
the struct gpio_chip with a ioctl()-like vtable member that I and
Alan Cox came up with as a response to the above.

I'm happy to implement either, or even both if you like :-D

Yours,
Linus Walleij
