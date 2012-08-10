Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2HJITN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:19:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33012 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab2HJITD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120809202054.GA24503@avionic-0098.mockup.avionic-design.de>
References: <1343044770-6591-1-git-send-email-thierry.reding@avionic-design.de>
	<CACRpkdaZcUvcJMUZTqCEU5FQYhE3EvSSfUEnEx0dYRt-6x5Nig@mail.gmail.com>
	<20120809202054.GA24503@avionic-0098.mockup.avionic-design.de>
Date: Fri, 10 Aug 2012 10:19:02 +0200
Message-ID: <CACRpkdaSk9xBaiSAKCj4Pa2kyyfP178XN53i2Q2+CBFx=RoE0g@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: Add Avionic Design N-bit GPIO expander support
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 10:20 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Sun, Jul 29, 2012 at 07:13:57PM +0200, Linus Walleij wrote:
>> > +       client->irq = irq_of_parse_and_map(client->dev.of_node, 0);
>> > +       if (client->irq == NO_IRQ)
>>
>> Just if (!client->irq) since NO_IRQ is 0 nowadays.
>
> At the risk of seeming pedantic, NO_IRQ is in fact quite often not 0.

No. A year back, yes, but not anymore. We went to great lengths in the
ARM architecture to ensure NO_IRQ is *always 0. Russell spent
a lot of time on this.

Consult the following article on LWN:
http://lwn.net/Articles/470820/

Then grep your gitlog and you'll see we got rid of it from ARM.

If this driver is for some other arch like openrisc I might accept
it but please reconsider.

Yours,
Linus Walleij
