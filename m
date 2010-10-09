Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0JIQS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:18:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55647 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0JIQS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x5ZZoNfvqJEw5I+bBazq+2UAqrwqucfhYMfn05+0fP6npb6r6qEZvqoZ+/AmyLEjxy
         e4L/Jaj9nqgNvs0LGD8cEKkpUzkRfyAf8jJuXeLFn/SiQRhc6DEYmqPLf67uJSRvBkH4
         cZha27HAZ3xZdhslJI2iZv7xFHcbNXttmnkAQ=
MIME-Version: 1.0
In-Reply-To: <20101009143709.GB25564@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
	<AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
	<201010091311.26335.arnd@arndb.de>
	<AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
	<AANLkTi=37SCuwwze4KS_yOdmi8bvJP_OexHaYLw-AXfJ@mail.gmail.com>
	<20101009143709.GB25564@n2100.arm.linux.org.uk>
Date: Sat, 9 Oct 2010 19:18:56 +0300
Message-ID: <AANLkTin-OpKVK+a=WPQFoPwCO7aJ4yTjqjw3EmGeBRBs@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, Arnd Hannemann <arnd@arndnet.de>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 5:37 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Oct 09, 2010 at 03:10:57PM +0300, Felipe Contreras wrote:
>> On Sat, Oct 9, 2010 at 2:43 PM, Dave Airlie <airlied@gmail.com> wrote:
>> >> The few drivers that may be hit by this are typically in drivers/staging
>> >> exactly because issues like this have not been fixed yet.
>> >>
>> >> We should probably just fix the non-staging drivers that are hit by
>> >> this now and declare the issue done.
>> >>
>> >> When you say that "many drivers broken", can you list the ones you know
>> >> about? It would probably help resolve this the right way.
>> >
>> > I'm guessing some closed source graphics drivers for ARM do all kinds
>> > of wrong crap, and Nokia use them a lot, and nobody wants to tell the
>> > closed vendors to change their drivers because it costs money.
>>
>> You are over simplifying things.
>>
>>  1) The code is open[1]
>>  2) the decision comes from TI, Nokia can only do so much before shipping
>
> Well -
>
> 1. TI had been complaining last December about vmalloc() creating mappings
>   with different shared-ness attributes causing problems with OMAP.
>
> 2. May 10, TI on the three-weekly conference call were warned about this
>   change to ioremap with system RAM - and this was noted in the minutes
>   and circulated.  It was brought up again on June 21st, and yet again
>   on August 2nd.
>
> So, the major players in the OMAP community were repeatedly made plainly
> aware of this change and some were aware of the problems caused by
> violating these kinds of restrictions.

My point was that Nokia was not the main entity to blame.

But anyway, I'm not too fond of secret meetings, the issues should be
discussed publicly.

> You tell me - if I've raised the issue on the mailing list to which OMAP
> people are aware of (and note that there was a reply from OMAP folk in
> the inital thread), if I've raised it several times with TI in conference
> calls which include the major players, and still OMAP drivers are doing
> things wrongly.
>
> You can lead the horse to water but you can not make it drink.  At some
> point it either drinks or dies.  In this case, it seems death is the
> favoured option as the warnings have been repeatedly ignored.

TI is not the owner of their drivers; the community is. I don't see
any mail from you on the linux-omap mailing list warning about
ioremap() changing behavior, nor do I think that would have been
enough warning, for OMAP, SH, or anybody else that might be affected.

All you are being asked is to make *one* release where the warning is
enabled but the behavior is not changed.

-- 
Felipe Contreras
