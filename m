Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1GFS6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:58:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60254 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab1GFS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:58:39 -0400
Date: Wed, 6 Jul 2011 11:58:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706185832.GA6086@core.coreip.homeip.net>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
 <20110706184759.GA3389@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706184759.GA3389@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 08:47:59PM +0200, Henrik Rydberg wrote:
> > > (C) A third, compromise implementation might be to do something like this:
> > >   (1) When >=2 fingers are on the pad, report 2 MT-B slots, where:
> > >     (a) slot[0] reports finger 1
> > >     (b) slot[1] reports finger 2
> > >     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
> > >   (2) If 1 finger is removed, the tracking_id for its slot is invalidated;
> > >       but, the finger that remains stays in its same slot with the
> > > same tracking_id.
> > >   (3) Whenever the number of fingers changes from/to 3 or more
> > > fingers, both slots are always invalidated.
> > >       New tracking_ids are assigned to both slots which contain the
> > > two fingers now being reported.
> > >   (4) No special driver property is required for this, not even "semi-mt".
> > >       It should be as pure MT-B as we can get (plus BTN_TOOL_* hack).
> 
> I believe there is a strong userspace assumption that BTN_TOOL_* has
> no meaning for real MT devices. Rightfully so, IMO. Hence, I think
> semi-mt needs to be used here as well.

I think we need to adjust userspace to pay attention to BTN_TOOL_* for
MT-B too so that if number of slots advertised does not match
BTN_TOOL_* capabilities that means that the device does not privide
tracking data for all contacts.

Luckily this should be backward-compatible (i.e. older userspace will
ignore "extended" fingercounts, newer will pay attention to it).

> 
> > > 
> > 
> > This is the best option in my opinion. We will present 2 finger position
> > data plus extended finger count.
> 
> We never did put all the details of the bounding box coordinates in
> writing, so perhaps this is an opportunity to both fix that and extend
> usability to the case so described. The only question is whether there
> are applications out there which now assume min/max instead of contact
> positions. If anyone knows, please speak up. :-) Otherwise, I am very
> much for Daniel's case C, with Dmitry's modification.
> 
> In short: Use the semi-MT property, and send two suitable fingers
> along with it.

Umm... but it is my understanding that 2 fingers will provide real
tracking data, not bounding box, so why would we set semi-MT?

Maybe we have different notions of what semi-MT property conveys? For me
semi-MT indicates that the device provides 2 coordinates for bounding
box.  However if semi-MT is not set does not mean that the device
provides true tracking for all contacts, but only for advertised slots.
There still may be additional data transmitted.

Thanks.

-- 
Dmitry
