Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1ECWeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:34:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61576 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1ECWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cWZG3IfaqagGac8R7jqTWn0EN4pWb3Z2mJJfvJvNnOljz7cE8vHsviQpG00HYryIbK
         aHrOWEY3uXcTt+weL+vfHS1yAZI0bUd6EQNZwnvCN5iAP3X5stBIgSErT3EjkTztnWu7
         +JF+uL4wxGt3nj1lWpznDSG0uQVIbESuaSEw0=
Date: Wed, 4 May 2011 02:34:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110503223415.GA14024@oksana.dev.rtsoft.ru>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <20110503210950.GA2866@ponder.secretlab.ca>
 <BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
 <20110503215211.GA8491@oksana.dev.rtsoft.ru>
 <20110503220408.GA6978@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110503220408.GA6978@pulham.picochip.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:04:08PM +0100, Jamie Iles wrote:
[...]
> The advantage that Grant's proposal has though is that the user can 
> override the gpio_chip callbacks.  When I tried porting over some 
> existing ARM platforms, one of the blocking issues was that lots of 
> platforms had some annoying small detail that was slightly different 
> (such as doing muxing in the _get() callback or needing a to_irq 
> callback).
> 
> If we make bgpio_chip public and return that from bgpio_probe 
> unregistered then the calling code can override some of the methods then 
> register the gpio_chip.

Oh, that makes sense, right.

> As a slight aside, if we don't want a platform_device per bank for 
> devices with multiple banks then I don't think the named resource 
> approach will work (at least I can't see a particularly nice mechanism).  
> Any ideas?

I think Grant misunderstood Alan's words. If a PCI device registers
platform devices to represent each of PCI device's banks -- that is not
good. It's waste of devices, complicates sysfs/device heirarchy and so
on. And that's why bgpio_probe() thing started, to not create platform
devices when you already have one.

But personally I think it's OK for platforms (arch/ code) to register
each bank as a separate device. In some cases, that describes hardware
even better. And that makes life easier for device-tree stuff as well.

And if you really don't want this behaviour for your platform, you can
create your own driver that would use "bgpio library", and would
register several banks for a single device (as in PCI case).

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
