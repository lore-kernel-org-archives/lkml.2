Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0E0W7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:59:44 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59595 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab0E0W7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:59:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BKgUpiay/pCvLYmBiWJzS38dnS5Y0y8W/peOieVCuk1cPRIgZaIwYjHoEnScOMIqLW
         2MGaWSwWsZNFD4Iz2cEbyCy2clLHUGgb1/FnsMSmgy9Oq6f+YLOtaeeFfdsPrREA0K9z
         xJTlyaFPdrTtzsse4237ntAEIko3rZzTRKuHY=
MIME-Version: 1.0
In-Reply-To: <20100527070310.GC17625@core.coreip.homeip.net>
References: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
	<20100525173446.GA4634@core.coreip.homeip.net>
	<4BFC2A7D.50501@euromail.se>
	<20100525202340.GD4455@core.coreip.homeip.net>
	<AANLkTimR3VN21URkandBGhPjWYdkdFP2zmAVscyRbqtW@mail.gmail.com>
	<20100527070310.GC17625@core.coreip.homeip.net>
Date: Thu, 27 May 2010 15:59:37 -0700
Message-ID: <AANLkTimbs_8uAMMS2KuXodgTcHAs_vWJgYhDblUPY1jU@mail.gmail.com>
Subject: Re: [PATCH 0/2] input: mt: Add EVIOC mechanism for MT slots
From: Ping Cheng <pinglinux@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:03 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, May 26, 2010 at 08:59:35AM -0700, Ping Cheng wrote:
>> On Tue, May 25, 2010 at 1:23 PM, Dmitry Torokhov
>> <dmitry.torokhov@gmail.com> wrote:
>> > On Tue, May 25, 2010 at 09:52:29PM +0200, Henrik Rydberg wrote:
>> >> Dmitry Torokhov wrote:
>> >> > Hi Henrik,
>> >> >
>> >> > On Tue, May 25, 2010 at 01:52:57PM +0200, Henrik Rydberg wrote:
>> >> >> These patches are in response to the discussion about input state
>> >> >> retrieval.
>> >> >>
>> >> >> The current EVIOCGABS method does not work with MT slots.  These
>> >> >> patches provides a mechanism where a slot is first selected via a call
>> >> >> to EVIOCSABS, after which the corresponding MT events can be extracted
>> >> >> with calls to EVIOCGABS.
>> >> >>
>> >> >> The symmetric operation, to set the MT state via EVIOCSABS, seems to
>> >> >> violate input data integrity, and is therefore not implemented.
>> >> >>
>> >> >
>> >> > This looks sane, however the question remains - is there any users for
>> >> > this data? Like I mentioned, I can see the need to fetch state of
>> >> > switches and ranges of absolute axis, and even non-multitouch ABS values
>> >> > (due to the fact that some input devices, like sliders, may stay in a
>> >> > certain position for long periods of time), but I expect multitouch data
>> >> > to be "refreshed" very quickly.
>> >> >
>> >> > Thanks.
>> >> >
>> >>
>> >> There were some voices addressing this issue, and the patches are here,
>> >> available for whomever to pick up. Drop them if you wish, I will not send them anew.
>> >>
>> >
>> > I'll save them in my queue but will hold off applying until I hear
>> > userspace folks requesting such functionality.
>>
>> Hi Dmitry,
>>
>> You do have a valid point - the (x,y) from a touch object would most
>> likely change all the time. Even if the object itself is in a steady
>> state on the digitizer, i.e., without any intentional movement, the
>> electronic noise would most likely lead to some (x,y) changes. So, the
>> chance that we need to retrieve (x,y) is rare.
>>
>> However, it is possibe that when X driver starts, an object was
>> already on the digitizer. And the digitizer is of such a high quality
>> :), it filtered all the noises so we can not locate the touch without
>> a EVIOCGABS call.
>>
>> Plus, from a pure coding/development point of view, it is not a bad
>> practice to provide the equivalent features for _MT_ support as we did
>> for the existing input devices. At least, it doesn't hurt to make the
>> support consistent across devices/tools (considering touch as a new
>> input device/tool).
>
> Ping,
>
> I did not say that there was a problem with the patch, I agree with it.
> However if no one using this - why should we bother? Will _you_ utilize
> this functionality in Wacom X driver? If so let me know and I will merge
> it.

tbh, I can not say that I will need it in my X driver for sure. But I
vote for it to be merged.

Thank you for placing me in such an important position :).

Ping
