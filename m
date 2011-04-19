Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1DSPGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:06:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51609 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DSPGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
References: <20110419145303.111aead7@endymion.delvare> <BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
 <20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Apr 2011 09:05:44 -0600
X-Google-Sender-Auth: AImtYOcPC4tKfcLFt50nL9A2Fwg
Message-ID: <BANLkTi=tzXyozCck9H03-2RErGsvSxrv1Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 8:54 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> In this particular case, you've got a PCI device which looks to be
>> going into config space to get some information about how the chip is
>> layed out.  What I would do is keep your existing pci probe & remove
>> hooks, but use them to create and register child basic_mmio_gpio
>> platform_devices for each gpio bank.
>
> That means more devices, weird sysfs heirarchies and lots of mess with
> runtime power management in the general case.
>
> If the basic_mmio_gpio code is properly abstracted it ought not to need
> magic extra platform devices.
>
> That aside it'll be less code to keep it separate than do all the messing
> around with platform devices so it seems to be a gross overdoing of 'lets
> make everything use the same code however big a hammer is needed'
>
> If it was a platform device it might make sense, if the config was
> platform config to create a device it would certainly make sense, in the
> PCI case it's smaller, cleaner and saner not to add insane layers of glue
> and indirection IMHO.

Doing a platform device is one solution that is pretty simple to
implement and I don't think adding child devices is at all a problem.
However, I'm not mandating that approach, and if you or Jean prefer to
abstract out the gpio accessors from basic_mmio_gpio(), then that is
fine by me.  The key issue it to avoid merging yet another, probably
subtly broken, set of GPIO accessor functions if it can at all be
avoided.

g.
