Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2KEM4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:56:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34534 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2KEM4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:56:03 -0500
Message-ID: <1352120159.10947.3.camel@hornet>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
From: Pawel Moll <pawel.moll@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Date: Mon, 05 Nov 2012 12:55:59 +0000
In-Reply-To: <1352108387.3212.12.camel@linaro1.home>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
	 <1352108387.3212.12.camel@linaro1.home>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Nov 2012 12:56:00.0232 (UTC) FILETIME=[E7AFD680:01CDBB54]
X-MC-Unique: 112110512560107801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 09:39 +0000, Jon Medhurst (Tixy) wrote:
> > +static void mmio_led_brightness_set(struct led_classdev *cdev,
> > +		enum led_brightness brightness)
> > +{
> > +	struct mmio_led *led = container_of(cdev, struct mmio_led, cdev);
> > +	unsigned long uninitialized_var(flags);
> 
> uninitialized_var seems to be a bit contentious, Linus Torvalds had a
> recent complaint about it which prompted Ingo to post a patch proposing
> to removing it: https://patchwork.kernel.org/patch/1655621/ So perhaps
> best to avoid using it ;-).
> 
> In this case, you could possibly keep gcc quite with something like:
> 
>         spinlock_t *lock = led->lock;
> 
> and then use the local variable 'lock' everywhere instead of led->lock.
> Or just keep it simple an initialise flags to 0 instead.

Yeah, = 0 will do...

> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	if (pdata->reg_size != 8 && pdata->reg_size != 16 &&
> > +			pdata->reg_size != 32)
> > +		return -EFAULT;
> 
> Is EFAULT appropriate here? Why not EINVAL?

Hm. To distinguish it from !pdata case I guess (and a 13 bit wide
transaction sounds like a fault to me ;-), but I can be persuaded
otherwise without much effort...

Thanks!

Paweł


