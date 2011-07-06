Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1GFSqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:46:07 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:35238 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1GFSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:46:04 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmdcAJGsFE5V5q1MPGdsb2JhbABTiQqefQsBAQEBNzKIfMM4DoYpBJdJizc
X-IronPort-AV: E=Sophos;i="4.65,488,1304287200"; 
   d="scan'208";a="27354674"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Jul 2011 20:47:59 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706184759.GA3389@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706174503.GA5695@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > (C) A third, compromise implementation might be to do something like this:
> >   (1) When >=2 fingers are on the pad, report 2 MT-B slots, where:
> >     (a) slot[0] reports finger 1
> >     (b) slot[1] reports finger 2
> >     (c) Total number of fingers on pad is indicated by EV_KEY/BTN_TOOL_* is set.
> >   (2) If 1 finger is removed, the tracking_id for its slot is invalidated;
> >       but, the finger that remains stays in its same slot with the
> > same tracking_id.
> >   (3) Whenever the number of fingers changes from/to 3 or more
> > fingers, both slots are always invalidated.
> >       New tracking_ids are assigned to both slots which contain the
> > two fingers now being reported.
> >   (4) No special driver property is required for this, not even "semi-mt".
> >       It should be as pure MT-B as we can get (plus BTN_TOOL_* hack).

I believe there is a strong userspace assumption that BTN_TOOL_* has
no meaning for real MT devices. Rightfully so, IMO. Hence, I think
semi-mt needs to be used here as well.

> > 
> 
> This is the best option in my opinion. We will present 2 finger position
> data plus extended finger count.

We never did put all the details of the bounding box coordinates in
writing, so perhaps this is an opportunity to both fix that and extend
usability to the case so described. The only question is whether there
are applications out there which now assume min/max instead of contact
positions. If anyone knows, please speak up. :-) Otherwise, I am very
much for Daniel's case C, with Dmitry's modification.

In short: Use the semi-MT property, and send two suitable fingers
along with it.

Cheers,
Henrik
