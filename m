Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1E0XzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:55:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49395 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1E0XzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:55:16 -0400
MIME-Version: 1.0
In-Reply-To: <1306531794.10752.19.camel@ptyser-laptop>
References: <1299022100-14564-4-git-send-email-ptyser@xes-inc.com>
 <1303317354-18188-1-git-send-email-ptyser@xes-inc.com> <20110527064238.GA31271@ponder.secretlab.ca>
 <20110527110130.4b3448f2@endymion.delvare> <1306506402.22090.14872.camel@petert>
 <20110527205526.GJ6645@ponder.secretlab.ca> <1306531794.10752.19.camel@ptyser-laptop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 27 May 2011 17:54:55 -0600
X-Google-Sender-Auth: BK3eeqw6BfaryrIAbzE-0aWaC7o
Message-ID: <BANLkTin9Cy_emoFDs5hgw52ohbbPDKcN9w@mail.gmail.com>
Subject: Re: [PATCH v6] gpio: Add support for Intel ICHx/3100/Series[56] GPIO
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Syed S Azam <Syed.Azam@hp.com>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 3:29 PM, Peter Tyser <ptyser@xes-inc.com> wrote:
>> > My own (completely biased) preference would be to use my driver as a
>> > starting point, primarily because it supports newer chips that require
>> > different access methods, as well as the older-style chips Jean's
>> > supports.  Its also been hanging out for about 6 months without many
>> > complaints, a tested-by, etc.
>>
>> I like the /structure/ of Jean's driver better, particularly that it doesn't
>> play games with the device model by registering devices at module load
>> time.
>
> But the driver shouldn't be a PCI driver - that's worse in my opinion
> than a platform driver.  Multiple drivers currently use the same PCI
> device ID as Jean's - they can't all claim the PCI device, so why should
> Jean's GPIO driver?  It seems incorrect, and likely to break things in
> the future.  Mine has its warts too, but it doesn't have the possibility
> of negatively affect other drivers at least, as well as supports more
> hardware.

Does it conflict with other drivers in the kernel right now?  If so,
then I'll drop it.

Also, you're directly describing the use case for an MFD type device.
I certainly expect either this driver or Jean's driver to be reworked
into an MFD style device in the next cycle.

>> If one device performs more than one function, then it should
>> register all the interfaces from a single probe, or go in the
>> direction of MFD devices and register a bunch of child
>> platform_devices.
>
> In this case its not really "one device performing more than one
> function", its one device specifying the location of other devices.  The
> device being claimed is used for FWH and IRQ configuration and happens
> to have a pointer to a GPIO device (among other things).  Claiming it
> for a GPIO device seems very wrong - it has very little to do with GPIO
> at all.

Are you sure?  My reading of the ICH10 manual is that the GPIO
controller is very much behind the LPC bridge, and that it is entirely
appropriate for the GPIO controller device to be registered by the PCI
driver as a child of the PCI device, or to be registered directly by
the PCI driver.

>
>> I'm going to merge Jean's driver and leave this one out for now
>> (sorry), but I reserve the right to replace Jean's with your driver in
>> the next merge window.  This is pretty much an arbitrary decision, but
>> I may as well merge at least one of them now instead of kicking both
>> out for another cycle.  It really seams to me like there is still
>> a few architectural issues to sort out in both drivers and to make
>> sure that one driver will be useful for both of you.
>
> I disagree with the logic, and its a bit frustrating to have a patch
> hanging out for 6 months to be superseded by a more recent change that
> seems to be more likely to cause conflicts.

Think about it this way; your patch wasn't going to go in this cycle
anyway due to the current concerns I have about structure, and I
haven't said no to it either in that I reserve the right to replace
Jean's version with a rework of this one in the next cycle if it makes
more sense to do so.  I'm sorry that I wasn't able to look at the
patch before now, but that is unfortunately how things happen
sometimes.  Believe me, I understand your frustration, but I cannot
merge this driver as is, and there isn't time to rework it before the
window closes.

I'm okay with Jean's patch because I like the structure and it looked
to be low risk.  However, if I'm wrong about it and it will indeed
conflict with another driver then let me know and I'll remove it.

g.
