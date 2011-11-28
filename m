Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1K1AUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 19:20:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1K1AUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 19:20:49 -0500
Date: Mon, 28 Nov 2011 09:19:41 +0900
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111128001941.GA2913@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111251402.28016.arnd@arndb.de>
 <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
 <20111127230836.GA29728@suse.de>
 <3f636639-7081-40f5-961d-72b1123c19a0@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f636639-7081-40f5-961d-72b1123c19a0@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 04:09:19PM -0800, Dmitry Torokhov wrote:
> >> So for the userspace part it seems to me that we need to make
> >> up our mind about this stuff: is it going to be through input or
> >> uevent like in this patch? Or ?both??
> >
> >Input please, uevent is not for things like switches that are "common",
> >but for things that are "uncommon" and don't happen often.
> 
> Actually, please do not. I never liked audio-related switches added to
> input; ALSA guys just wore me down. These are usually not switches
> that user can flip, they are connections between components. Should we
> switch betide_carrier_*(), power supply state, etc, etc over to input?
> I think not.

Yes, I think so :)

Well, not all of them, but when there is a hardware change of state,
that a user can make happen (plug in headphone, plug in usb port, etc.)
they should be input events, as there are a zillion different ways to
have these types of devices.

And as HID has already documented almost all of these already, odds are,
there's already a HID mapping for what is needed to be exported, and if
not, it's easy to get a new HID code added, right?

> I haven't looked at the patch yet, but a class that has an attribute
> that could be queried and emitting uneventful on state change seems
> like a good diluting for me.

For this one case, maybe.  But what about the next one, and the next
one, and so on.  I would think those would all map better to input than
one-off class devices with custom uevent messages.

Unless we want to start piping input events through uevents?  :)

Ok, if you really don't want this, then I suggest we create something
that encompasses all of these into something unified, much like IIO is
trying to be for those types of devices.

thanks,

greg k-h
