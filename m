Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0IGTNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:13:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58102 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab0IGTNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vGiBeCue1RSaanLa+uEESB0XyjxqGD/TBdu3SqNVzKpBrnZ2LzBy61Mok6iAw3zAeS
         bRLHByqyO/H14RiAkGOOtjcmyfmMyLnpl7dqKbOX7GcWsGNDLlEYD9u70lSMxPjRMXSK
         EgeNoR7nP3qFpBpHpn0wxg0pTIxMrjHzSsatI=
MIME-Version: 1.0
In-Reply-To: <569801.35222.qm@web180310.mail.gq1.yahoo.com>
References: <4C85BEFD.402@bluewatersys.com>
	<569801.35222.qm@web180310.mail.gq1.yahoo.com>
Date: Tue, 7 Sep 2010 21:13:12 +0200
Message-ID: <AANLkTinq98+ryOOKx1o1o21x9VnHz3nRCHh=5Wwixn4o@mail.gmail.com>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
From: "avictor.za@gmail.com" <avictor.za@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.y.miao@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        bn@niasdigital.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> NAK still.  You're trying to abuse gpio_is_valid(),
> which I see no need to support.
>
> In terms of GPIO framework architecture, zero is
> the first GPIO in all cases, and is always
> a valid GPIO number, even if it's not
> requestable/swritable/readable on a given board.
>
> Whether it's usable on a given platform depends
> on whether a GPIO controller is registered which
> claims numbers 0..N ... (assuming gpiolib in use).

How should the following be done in a driver then?

   if (gpio_is_valid(device->output_pin)) {
         if (gpio_request(device->output_pin, "driverX") != 0)
             goto error_handling;

         /* continue with gpio setup */
    }
    else {
        /* there is no vcc_pin, so don't do any gpio setup */
    }

    ....

   if (gpio_is_valid(device->output_pin)) {
       /* set value high */
   }


Regards,
  Andrew Victor
