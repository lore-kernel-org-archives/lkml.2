Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2KZQKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:10:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50425 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2KZQKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:10:40 -0500
Message-ID: <1353946235.10271.11.camel@hornet>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Date: Mon, 26 Nov 2012 16:10:35 +0000
In-Reply-To: <CA+E=qVcjKz-3CAKrDVG+ymij5HAB5H=a9+4G0KOR0tTKLGJu4w@mail.gmail.com>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
	 <CA+E=qVcjKz-3CAKrDVG+ymij5HAB5H=a9+4G0KOR0tTKLGJu4w@mail.gmail.com>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Nov 2012 16:10:36.0063 (UTC) FILETIME=[91B302F0:01CDCBF0]
X-MC-Unique: 112112616103906201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 15:37 +0000, Vasily Khoruzhick wrote:
> On Thu, Nov 1, 2012 at 8:58 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> > LEDs are often controlled by writing to memory mapped
> > register. This patch adds:
> >
> > 1. Generic functions for platform code and drivers to create
> >    class device for LEDs controlled by arbitrary bit masks.
> >    The control register value is read, modified by logic AND
> >    and OR operations with respective mask and written back.
> >
> > 2. A platform driver for simple use case when one or more LED
> >    are controlled by consecutive bits in a register pointed
> >    at by the platform device's memory resource. It can be
> >    particularly useful for MFD cells being part of an other
> >    device.
>
> This MMIO controls some latch (or whatever) which is actually GPIO.
> So implementing generic GPIO MMIO driver and using leds-gpio on top of
> it appears to be a better solution for me.

I won't argue that it is doable - I don't even have to implement the
MMIO GPIO driver, because my MFD already has a set of pseudo-GPIO lines
and extending those won't be a problem at all an I'll do exactly that if
there is no other choice. But at the same time I hope you would agree
that my_code->gpio_controller->gpio_led_description->register_device
chain is longer than my_code->mmio_led one if you want to add a single
"status" led for your little board ;-). I don't event mention that at
least couple of the existing drivers follow the same "MMIO pattern"
blindly.

Nevertheless I'd really like to hear from the maintainers...

Thanks!

Paweł


