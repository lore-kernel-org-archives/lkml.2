Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2KMR6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:58:46 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:58341 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab2KMR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:58:32 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai+wAOGJolBV5h1yPGdsb2JhbABEhTGFI7gmAgF+GQEBAQEfGQ0ngh4BAQQBOhwjBQsIA0YUJQoaLodpCqoVkC0UjQ+BfoJ8YQOVe4V7jTk
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="224964773"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 19:04:53 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/13] HID: hid-multitouch: support for hovering
 devices
Message-ID: <20121113180453.GA3622@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-12-git-send-email-benjamin.tissoires@gmail.com>
 <20121113164239.GA712@polaris.bitmath.org>
 <CAN+gG=EbAdfOG_vwt2uamV+JcAKLFqM=zTo9oRQ9RLayrpdsoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EbAdfOG_vwt2uamV+JcAKLFqM=zTo9oRQ9RLayrpdsoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > Why [-1,1] here?
> 
> At first, I only used [0,1]. However, it's still the same problem with
> the information being kept between the touches:
> if you start an application after having touched your device, you
> normally have to ask for the different per-touche states to get x, y,
> distance, pressure, etc...
> However, this is not much mandatory because the protocol in its
> current form ensures that you will get the new states of the axes when
> a new touch occurs.

Right, the stateful communication requires a full state read after
opening the deivce, although in most cases this is not really
necessary. This is no different for ABS_MT_DISTANCE, of course.

> ABS_MT_DISTANCE is a little bit different here because the protocol
> guarantees that once you get the "not in range" state through
> tracking_id == -1, distance should be 1.
> When the new touch of the very same slot occurs, you also have the
> guarantee that distance is at 1 too.

ABS_MT_DISTANCE is just another attribute of the slot, so it really is
no different.

> So basically, if you don't ask for the slot states, you will never get
> that very first distance.

Which will not be important either; as long as the slot is unused, it
does not matter what the attributes of that slot are.

> I know that it's a user-space problem, but honestly, I don't want to
> fix several user-space problems when we could fix it through the
> protocol.
> 
> I can see 2 solutions:
> - set the range to: [0,1] and still sending -1 (or 2) for the invalid
> distance value (if it's not clamped)
> - set the range to: [0,2] and having: 0 for touch, 1 for hovering, and
> 2 for not in range
> 
> Does that make sense?

I just do not see what problem you want to solve here.

Thanks,
Henrik
