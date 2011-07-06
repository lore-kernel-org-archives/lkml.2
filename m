Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1GFVhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:37:06 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50260 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab1GFVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:37:04 -0400
Date: Wed, 6 Jul 2011 14:36:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Daniel Kurtz <djkurtz@chromium.org>,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706213658.GA9409@core.coreip.homeip.net>
References: <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
 <20110706184759.GA3389@polaris.bitmath.org>
 <20110706185832.GA6086@core.coreip.homeip.net>
 <20110706193120.GA3884@polaris.bitmath.org>
 <20110706200056.GB6086@core.coreip.homeip.net>
 <20110706202049.GA4077@polaris.bitmath.org>
 <4E14D22D.8050108@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14D22D.8050108@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 02:22:53PM -0700, Chase Douglas wrote:
> On 07/06/2011 01:20 PM, Henrik Rydberg wrote:
> >>> To me, it seems we do need a little bit of extra information to
> >>> determine this new type of device.
> >>
> >> I think we already have all we need (see above).
> > 
> > I concur. So, to conclude:
> > 
> > a) The improved synaptics behavior can be achieved by simply using
> > MT-B plus BTN_TOOL_*.
> > 
> > b) Userspace should check BTN_TOOL_* for any discrepancies between the
> > maximum number of available slots (always two in this case) and the
> > maximum number of fingers reported (BTN_TOOL_TRIPLETAP etc). Extra
> > actions may then be taken to support more fingers than slots.
> > 
> > c) The semi-mt flag is only used to signal that the two points sent
> > via MT-B are the corners of a bounding box.
> 
> This isn't quite enough. If we don't set the semi-mt flag or any other
> new flag, then we'll have slots that become inconsistent when touches
> are added or removed. For example, start with two touches being tracked
> correctly. Now, add a touch. The second slot will now get the data of
> the third touch, which is in a different location. You haven't changed
> the tracking_id though, so it looks like the same touch. This is
> incorrect behavior. Or, you could change the tracking_id, but that
> implies that a touch was lifted and another was placed. This is also
> incorrect behavior.

The tracking ID needs to be changed as we start trackign and reporting
new touch. We could see that the old touch was not removed from the fact
that total number of finger reported increased.

> 
> We need to tell userspace that this is a messed up device that can't
> accurately track touch locations across touch up/down boundaries. Once
> userspace sees this, it can act appropriately when it sees a transition
> from BTN_TOOL_DOUBLETAP to BTN_TOOL_TRIPLETAP, for example. This is how
> we handle transitions in the uTouch stack for semi-mt devices.
> 
> Perhaps a clean implementation would be to keep semi-mt as a flag
> stating that there will only ever be two slots, the 0th will be the
> minimum (x,y) of the bounding box and the 1st will be the maximum. Then,
> we add a flag like NO_TOUCH_TRANSITION_TRACKING that would be set on
> both semi-mt and these new devices that denote the slot data may
> transition from one physical touchpoint to another when the number of
> touches changes.
> 
> We could leave this up to userspace and have it detect a
> NO_TOUCH_TRANSITION_TRACKING device based on the fact that the max slots
> is less than the max fingers, but I would argue here that a more clear
> protocol is a better protocol.

I'll ask this - how much realistically do we care about 3+ finger
transitions in context of these particular devices? This is a touchpad
so as long as basic 2 finger gestures work (zoom, pinch, 2-finger
scroll) with Synaptics X driver we should be fine. I do not want to add
all kinds of custom flags to the protocol to deal with this generation
of touchpads.

It sounds to me like latest generation of Synaptocs protocol is a dud
and hopefully they will fix it to something more flexible in the next
generationof chips...

Thanks.

-- 
Dmitry
