Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0E0HDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:03:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47078 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0E0HDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CZQsS60XW/AjOXxXMQ9RKqJccbJYswUrVOe0y5QPFvOStjK00taAz6vKFIL9bJybCL
         kYbPVb/5rvhSyri7iwrDC2xsKL6AjFYfq7/ZNcXUO4o5WyRyIoYEXf8nUaAEcxHHeYby
         hU854w1aYXPJscewzOtbf9GoVAfvXLr9e8VtY=
Date: Thu, 27 May 2010 00:03:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 0/2] input: mt: Add EVIOC mechanism for MT slots
Message-ID: <20100527070310.GC17625@core.coreip.homeip.net>
References: <1274788379-11026-1-git-send-email-rydberg@euromail.se>
 <20100525173446.GA4634@core.coreip.homeip.net>
 <4BFC2A7D.50501@euromail.se>
 <20100525202340.GD4455@core.coreip.homeip.net>
 <AANLkTimR3VN21URkandBGhPjWYdkdFP2zmAVscyRbqtW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimR3VN21URkandBGhPjWYdkdFP2zmAVscyRbqtW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 08:59:35AM -0700, Ping Cheng wrote:
> On Tue, May 25, 2010 at 1:23 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Tue, May 25, 2010 at 09:52:29PM +0200, Henrik Rydberg wrote:
> >> Dmitry Torokhov wrote:
> >> > Hi Henrik,
> >> >
> >> > On Tue, May 25, 2010 at 01:52:57PM +0200, Henrik Rydberg wrote:
> >> >> These patches are in response to the discussion about input state
> >> >> retrieval.
> >> >>
> >> >> The current EVIOCGABS method does not work with MT slots.  These
> >> >> patches provides a mechanism where a slot is first selected via a call
> >> >> to EVIOCSABS, after which the corresponding MT events can be extracted
> >> >> with calls to EVIOCGABS.
> >> >>
> >> >> The symmetric operation, to set the MT state via EVIOCSABS, seems to
> >> >> violate input data integrity, and is therefore not implemented.
> >> >>
> >> >
> >> > This looks sane, however the question remains - is there any users for
> >> > this data? Like I mentioned, I can see the need to fetch state of
> >> > switches and ranges of absolute axis, and even non-multitouch ABS values
> >> > (due to the fact that some input devices, like sliders, may stay in a
> >> > certain position for long periods of time), but I expect multitouch data
> >> > to be "refreshed" very quickly.
> >> >
> >> > Thanks.
> >> >
> >>
> >> There were some voices addressing this issue, and the patches are here,
> >> available for whomever to pick up. Drop them if you wish, I will not send them anew.
> >>
> >
> > I'll save them in my queue but will hold off applying until I hear
> > userspace folks requesting such functionality.
> 
> Hi Dmitry,
> 
> You do have a valid point - the (x,y) from a touch object would most
> likely change all the time. Even if the object itself is in a steady
> state on the digitizer, i.e., without any intentional movement, the
> electronic noise would most likely lead to some (x,y) changes. So, the
> chance that we need to retrieve (x,y) is rare.
> 
> However, it is possibe that when X driver starts, an object was
> already on the digitizer. And the digitizer is of such a high quality
> :), it filtered all the noises so we can not locate the touch without
> a EVIOCGABS call.
> 
> Plus, from a pure coding/development point of view, it is not a bad
> practice to provide the equivalent features for _MT_ support as we did
> for the existing input devices. At least, it doesn't hurt to make the
> support consistent across devices/tools (considering touch as a new
> input device/tool).

Ping,

I did not say that there was a problem with the patch, I agree with it.
However if no one using this - why should we bother? Will _you_ utilize
this functionality in Wacom X driver? If so let me know and I will merge
it.

-- 
Dmitry
