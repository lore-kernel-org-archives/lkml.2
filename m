Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2KVUMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:12:31 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33649 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2KVUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:12:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121120205421.GA4664@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
	<1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
	<20121114195852.GA14840@polaris.bitmath.org>
	<50A40CB3.8070105@gmail.com>
	<20121116200926.GA652@polaris.bitmath.org>
	<CAN+gG=F=bHdJF0=0LHGuVQ+ObHvWKJnL0GYcAEWBeD+Z-yyGSA@mail.gmail.com>
	<20121120205147.GA4658@polaris.bitmath.org>
	<20121120205421.GA4664@polaris.bitmath.org>
Date: Thu, 22 Nov 2012 21:12:24 +0100
Message-ID: <CAN+gG=HY3ai3sKqbqMoiFNHW+c8=dUKGXzF1sU-JaZ16_w1S9w@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Peter Hutterer <peter.hutterer@who-t.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

well, I'm not very satisfied with this patch. I first thought it was a
good idea but I can see now several cons:
1. Henrik would like to partially base the time spent between two
events when the device wraps on the *event* time. This is a great idea
for consistency, but I'm afraid I won't be able to implement it
because this time is computed *after* we call input_event and is only
used by evdev. Thus, I still need to add an other clock and some
differences may occur.
2. the user space (at least X) will not use it before a long time:
they already have the time of the event and it will not add that much
consistency.
3. it will wake up the whole input chain when fingers are present but
no moves occurs on the digitizer: the only events we get are
MSC_TIMESTAMP and EV_SYN and the user-space will be awaken just for
that.
4. MSC_TIMESTAMP does not have an abs_max value, thus we are forced to
compute sth consistent in the kernel that can be forwarded to the user
space.

So, I propose not to include this feature, and eventually reverting
the patch that introduced MSC_TIMESTAMP as it's useless if we don't
use it right now.

Jiri, Dmitry, Henrik, are ok with that?

Cheers,
Benjamin

On Tue, Nov 20, 2012 at 9:54 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> below logical_max (say),
>
> That was meant to read (logical_max / 2).
>
> Henrik
