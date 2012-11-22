Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2KVVDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:03:00 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:58769 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2KVVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:02:57 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5hALKRrlBV5h1yPGdsb2JhbABEhT2FI7MYg3AXAwEBAQEfGQ0ngh4BAQQBOhwjBQsIA0YUJQoaiBoKwA4UkBNhA5YAhXuDTolq
X-IronPort-AV: E=Sophos;i="4.83,303,1352070000"; 
   d="scan'208";a="230621564"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 22 Nov 2012 22:03:24 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
Message-ID: <20121122210324.GA593@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
 <20121114195852.GA14840@polaris.bitmath.org>
 <50A40CB3.8070105@gmail.com>
 <20121116200926.GA652@polaris.bitmath.org>
 <CAN+gG=F=bHdJF0=0LHGuVQ+ObHvWKJnL0GYcAEWBeD+Z-yyGSA@mail.gmail.com>
 <20121120205147.GA4658@polaris.bitmath.org>
 <20121120205421.GA4664@polaris.bitmath.org>
 <CAN+gG=HY3ai3sKqbqMoiFNHW+c8=dUKGXzF1sU-JaZ16_w1S9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=HY3ai3sKqbqMoiFNHW+c8=dUKGXzF1sU-JaZ16_w1S9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> well, I'm not very satisfied with this patch. I first thought it was a
> good idea but I can see now several cons:
> 1. Henrik would like to partially base the time spent between two
> events when the device wraps on the *event* time. This is a great idea
> for consistency, but I'm afraid I won't be able to implement it
> because this time is computed *after* we call input_event and is only
> used by evdev. Thus, I still need to add an other clock and some
> differences may occur.

Alternatively, device times need to become part of input core.

> 2. the user space (at least X) will not use it before a long time:
> they already have the time of the event and it will not add that much
> consistency.

Ok.

> 3. it will wake up the whole input chain when fingers are present but
> no moves occurs on the digitizer: the only events we get are
> MSC_TIMESTAMP and EV_SYN and the user-space will be awaken just for
> that.

Good point, and a second argument for including this in the input core.

> 4. MSC_TIMESTAMP does not have an abs_max value, thus we are forced to
> compute sth consistent in the kernel that can be forwarded to the user
> space.

Granted, but we do not really lose anything by doing so.

> So, I propose not to include this feature, and eventually reverting
> the patch that introduced MSC_TIMESTAMP as it's useless if we don't
> use it right now.
> 
> Jiri, Dmitry, Henrik, are ok with that?

I think it is fine to postpone the patch, but based on the comments
above, I do not think we need to revert the input definition.

Thanks,
Henrik
