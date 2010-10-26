Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab0JZOrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:47:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45866 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0JZOru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xRa7YO5EgbXjjE/lrsC4q2BfKF2y2uJTofwHQ46ifn1aX8eKd1mAfgJr/Q79RTSR3V
         sx3FKigUE0R5yYrSuRp37WFqFSXMhbHC6Q8c8fPs1OkVftVs0K7zwQQ3GjeLNxBMZVJ4
         Ls0uN/P70fVcdVMA/iHwlSsqpHbF8CmN9IbhA=
MIME-Version: 1.0
In-Reply-To: <1287472188-10101-2-git-send-email-samu.p.onkalo@nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
	<1287472188-10101-2-git-send-email-samu.p.onkalo@nokia.com>
Date: Tue, 26 Oct 2010 10:47:48 -0400
Message-ID: <AANLkTikWvRKzr+kffcpTHTs3q3TLeUPzdwzuQSR_tSU2@mail.gmail.com>
Subject: Re: [PATCHv4 1/5] misc: Driver for bh1770glc / sfh7770 ALS and
 proximity sensor
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: akpm@linux-foundation.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

010/10/19 Samu Onkalo <samu.p.onkalo@nokia.com>:

> This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
> ALS and proximity sensor.
>
> Interface is sysfs based. The driver uses interrupts to provide new data.
> The driver supports pm_runtime and regulator frameworks.
> (...)
> +static DEVICE_ATTR(prox0_raw_en, S_IRUGO | S_IWUSR, bh1770_prox_enable_show,
> +                                               bh1770_prox_enable_store);
> +static DEVICE_ATTR(prox0_thresh_above1_value, S_IRUGO | S_IWUSR,
> +                                               bh1770_prox_abs_thres_show,
> +                                               bh1770_prox_abs_thres_store);
> +static DEVICE_ATTR(prox0_thresh_above0_value, S_IRUGO | S_IWUSR,
> +                                               bh1770_get_prox_thres,
> +                                               bh1770_set_prox_thres);
> +static DEVICE_ATTR(prox0_raw, S_IRUGO, bh1770_prox_result_show, NULL);

So you have sysfs entries for enabling, calibrating hysteris
(above/below) and the reading the raw value which I assume
will be 0 (if nothing is in proximity) or 1 (if it is in proximity).

These entries are pretty OK I think, but the transition from
0 to 1 which I assume will generate an interrupt and generate
a new value in this attribute.

But should it not hook into the input framework and generate
a SW_FRONT_PROXIMITY event as well?

I think this could be pretty helpful for generic userspace
applications like X that want to use this event.

Of course I can send a patch for this later, but I'd like
to hear whether you agree on this or not.

Yours,
Linus Walleij
