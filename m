Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2BFI7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:59:08 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:55569 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2BFI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:59:07 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiFTAKuVL09V5qrvPGdsb2JhbABDiVKlZhkBAQEBNzKBcgEBBAE6HCMFCwgDDjgUJQoaiA8DuHkTi1cCAgkFDAcGAQQBAQkEFAcED4J8AgsDBBoEAoEJEoJWYwSVJ4VojHU
X-IronPort-AV: E=Sophos;i="4.73,369,1325458800"; 
   d="scan'208";a="1804117049"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 6 Feb 2012 10:00:28 +0100
To: Daniel Kurtz <djkurtz@google.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Input: Add EVIOC mechanism for MT slots
Message-ID: <20120206090028.GA4137@polaris.bitmath.org>
References: <1328515542-3779-1-git-send-email-rydberg@euromail.se>
 <CAGS+omD9aVcLKZnTi=8FfpUxeERHxxrWr4NM2GX+1LL1716awQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omD9aVcLKZnTi=8FfpUxeERHxxrWr4NM2GX+1LL1716awQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Instead of returning the values of just one event type, can you please
> return values for all defined MT event types for all slots?  Userspace
> can already know how big such an array would be required, since it can
> probe to determine how many ABS_MT types have been defined.

Userland does not always want all MT values, it depends on which are
in actual use. Having an ioctl that returns the values for a single
event code therefore makes sense. We also have to care about the
restrictions of the ioctl interface: Even with the present patch, we
are limited to 4000 slots, since we can only specify a buffer size of
16 kilobytes.

> It seems like the most common use case for this API is to fetch the
> complete "initial state" when a userspace program first attaches to a
> (stateful) evdev device.  Fetching all at once would be slightly more
> efficient, and would resolve (or at worst minimize) race conditions
> that could occur if input events are arriving while userspace is still
> slowly ioctl'ing out the event type initial states, one at a time.

The same argument applies to _all_ input events, but in practise, only
a few less frequent events really need to be looked up. I agree that a
one-call-captures-all function would not hurt in some situations, but
I do not think it is justified in this case.

The race condition is present regardless of the method used. Looking
at input events as a whole, a method to capture the state in
conjunction with opening the device would be good, but that problem is
of quite a different scope.

> If there are strong use cases for 'just probe one event type', perhaps
> you can keep the proposed API, but allow a special event type value,
> like "ABS_MT_*", to fetch all?

I really think "all" is less useful; a bitmask of wanted values would
make more sense. You are welcome to supply such a patch. ;-)

> BTW, I am very happy that you are finally plugging this particular
> issue since it has been bugging me for many months.  We sometimes use
> a userspace tools to record evdev events for a touch device while a
> user is performing a multitouch gesture.  If the userspace tool starts
> while there are already contacts on the device, there is currently no
> unambiguous way to determine what that initial state should have been.
>  Thus, some information is always lost.  This patch would allow us to
> address this in the tools.  I've just been to busy/lazy to propose a
> fix of my own :).

Yep, this goes for all of us. :-)

Cheers,
Henrik
