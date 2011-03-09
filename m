Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1CIQPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:15:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41034 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab1CIQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:15:52 -0500
MIME-Version: 1.0
In-Reply-To: <4D75317F.2090501@metafoo.de>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D7326B0.6050706@metafoo.de>
	<4D732B25.2010708@metafoo.de>
	<AANLkTinJM4YNL-H-QKtsqTWwRksK=__KUCgY5wDP-c+E@mail.gmail.com>
	<4D75317F.2090501@metafoo.de>
Date: Wed, 9 Mar 2011 10:15:52 -0600
Message-ID: <AANLkTimYZ3GP8oWafOvotwT7kA4Sj26-=gb=T0SbhJ-p@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter:

On Mon, Mar 7, 2011 at 1:26 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> I was thinking about an interface similar to gpio_to_irq. So you could map a
> PWM device to a IRQ number and use the existing the existing genirq framework
> to manage the callback handler.

I really like this idea, though at the moment I don't see clearly how
to implement it.  I'm just a little rusty on those data structures,
that's all.

I'm going to pull all of the callback functionality out of the API,
and will take it as a task to make something like this possible in a
future update:

struct pwm_device *p;
request_irq(pwm_to_irq(p), my_pwm_callback, ...);

> Maybe I'm on the wrong track here though. Could you explain what your expected
> use case is for this part of the API? For example what would a driver using a
> PWM device normally be doing in the handler it passed to the PWM device?

Honestly, I'm not really sure how useful the callback functionality
is.  In fact, it's probably a bad idea to offer it because it allows
someone to do pulse counting for things like stepper motors, and I'm
already thinking about an API for that.  Abusing a PWM to do pulse
counting is pretty CPU-intensive.

The only time end-of-period interrupts come up is when someone wants
to do a coordinated stop i.e. doesn't want a short pulse.  But that's
really a concern for the driver, not users.

So in the above where I said that I might put the callback-like
functionality back into the API, actually I might not.  :)


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
