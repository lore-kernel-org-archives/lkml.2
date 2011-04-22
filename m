Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1DVLgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:36:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58183 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab1DVLgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XXSqINHNhVx1+E26jmv59h+EEI8Cz++t+H09r5GF8CVAz0ELBiqPnrHk31B19yADcA
         33RswZh0+24l1hQdpGB+SRcuI6FjYSyF8Ae/oKI9C2QGlmy6cYRdFujzGbjW3M7W5bXT
         TDqFaR9Jc5SVcRU/8sJSOlJ1Ms/7Ad/PLltB4=
MIME-Version: 1.0
In-Reply-To: <BANLkTinrtoGhL3CXJZGWzf8+BwFSRsdk0w@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTinrtoGhL3CXJZGWzf8+BwFSRsdk0w@mail.gmail.com>
Date: Fri, 22 Apr 2011 13:36:44 +0200
X-Google-Sender-Auth: 3NA-nkd_1-YLeZRA9tOymIbLNpA
Message-ID: <BANLkTikDCmH-WX1u3e9c7gc2U9HJ88RBUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/21 Stijn Devriendt <highguy@gmail.com>:

> There's a couple of things I added on top of what you already seem to have:
> - in include/linux/of_gpio.h the of_gpio_flags were extended to
> support open-drain in device-trees.

Device tree support can very well be handled as an add-on I believe,
please feel free to do that on top of my patch set :-)

> - the debugfs support in gpiolib was also updated to export the current state to
>  the user through sysfs.

Hm, I've rewritten the mechanism (see latest patch set) to just take
anonymous parameter and argument. This means it's hard to do
this in any generic manner, and debugfs printing och config parameters
need to be pushed to each driver.

> I'd also like to add (if not already mentioned by others) that in
> general drivers that use GPIOs are unaware of their physical
> connection on the board. Having this information
> in device-tree or platform-data equivalent solves this.

Yes, this has been mentioned a few times, and a few times I have
replied that there is not one word in the patch set that says anything
about whether drivers or board code or whatever shall make use of
the mechanism, it's just an interface...

I don't understand why this keeps popping up, have I written
*anything* unclear about this?

> Secondly I tend to disagree with the "silently ignored" case when the
> underlying driver
> does not support setting drive mode. You can easily break the chip if
> setting the drive
> mode fails (although the HW designers may have selected the faulty
> chip then ;) ).

In the latest version the config operation returns an error code.

Yours,
Linus Walleij
