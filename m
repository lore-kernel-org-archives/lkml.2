Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0JUKOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:14:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40917 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0JUKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:14:04 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <201010211104.28555.arnd@arndb.de>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <201010192308.02018.arnd@arndb.de> <AANLkTikz-_qhjygzek4tR0CtDLih3ZQyy1mPKnXAiOiV@mail.gmail.com>
 <201010211104.28555.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Oct 2010 12:13:42 +0200
Message-ID: <AANLkTimWG_38hY2Xq=G7r42eP+zmA24Gaw4-hLVJstVA@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 21 October 2010, Ohad Ben-Cohen wrote:
>> This sounds like adding a set of API that resembles spin_{unlock,lock}_irq.
>>
>> My gut feeling here is that while this may be useful and simple at
>> certain places, it is somewhat error prone; a driver which would
>> erroneously use this at the wrong place will end up enabling
>> interrupts where it really shouldn't.
>>
>> Don't you feel that proving a simple spin_lock_irqsave-like API is
>> actually safer and less error prone ?
>>
>> I guess that is one of the reasons why spin_lock_irqsave is much more
>> popular than spin_lock_irq - people just know it will never screw up.
>
> People can screw that up in different ways, e.g.

Sure...

> I use the presence of spin_lock_irqsave in driver code as an indication
> of whether the author had any clue about locking. Most experienced
> coders use the right version intuitively, while beginners often just
> use _irqsave because they didn't understand the API and they were told
> that using this is safe.

Agree.

I'll add the _irq pair of APIs, this will make the users' code
cleaner. This is valuable especially since all of our current users
have their interrupts enabled anyway.

The change is also pretty trivial:

* move the internal locking implementation to raw_ methods
* the raw_ methods would save the current interrupt state only if
given a placeholder
* wrap those raw_ methods with the desired API (but only support the
_irq and _irqsave flavors)

Thanks,
Ohad.
