Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2IDQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:58:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35079 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2IDQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120904135022.GI9805@redhat.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
	<20120903143018.GA5353@redhat.com>
	<CAJK669bkHHMAPYMEr22-6uOwfgJv1uKTbzNBQVVCq=OooExC0g@mail.gmail.com>
	<20120903202737.GD6181@redhat.com>
	<CAJK669ZvnnG6fGOog-Z47B7xqyn9hcx5dAD7S--+2PSgE+hrLA@mail.gmail.com>
	<20120904135022.GI9805@redhat.com>
Date: Tue, 4 Sep 2012 18:58:47 +0200
Message-ID: <CAJK669Z1UYakBWartChfoeKL_eU5=GFZMGhH8R_Q-difVm0ygQ@mail.gmail.com>
Subject: Re: [RFC 1/2] virtio_console: Add support for DMA memory allocation
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

> Exactly. Though if we just fail load it will be much less code.
>
> Generally, using a feature bit for this is a bit of a problem though:
> normally driver is expected to be able to simply ignore
> a feature bit. In this case driver is required to
> do something so a feature bit is not a good fit.
> I am not sure what the right thing to do is.

I see - so in order to avoid the binding between driver and device
there are two options I guess. Either make virtio_dev_match() or
virtcons_probe() fail. Neither of them seems like the obvious choice.

Maybe adding a check for VIRTIO_CONSOLE_F_DMA_MEM match
between device and driver in virtcons_probe() is the lesser evil?

Regards,
Sjur
