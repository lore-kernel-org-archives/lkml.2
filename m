Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1GFT3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:29:23 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:42056 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1GFT3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:29:21 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmdcAKS2FE5V5q1MPGdsb2JhbABTiQqefQsBAQEBNzKIegLDRA6GKQSXSYs3
X-IronPort-AV: E=Sophos;i="4.65,488,1304287200"; 
   d="scan'208";a="1746073016"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Jul 2011 21:31:20 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706193120.GA3884@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
 <20110706184759.GA3389@polaris.bitmath.org>
 <20110706185832.GA6086@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706185832.GA6086@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I believe there is a strong userspace assumption that BTN_TOOL_* has
> > no meaning for real MT devices. Rightfully so, IMO. Hence, I think
> > semi-mt needs to be used here as well.
> 
> I think we need to adjust userspace to pay attention to BTN_TOOL_* for
> MT-B too so that if number of slots advertised does not match
> BTN_TOOL_* capabilities that means that the device does not privide
> tracking data for all contacts.

Well, it is possible, but it is a great deal more complex than just
looking at what the slots contain. At least we should all be able to
agree that MT-B is sufficient for any "proper" MT device.

> Luckily this should be backward-compatible (i.e. older userspace will
> ignore "extended" fingercounts, newer will pay attention to it).

OTOH, letting semi-mt engulf all devices which requires the use of
BTN_TOOL_* for finger count makes it easier to differentiate between
various userspace support levels. "This app supports pure MT-B only",
etc.

> > > This is the best option in my opinion. We will present 2 finger position
> > > data plus extended finger count.
> > 
> > We never did put all the details of the bounding box coordinates in
> > writing, so perhaps this is an opportunity to both fix that and extend
> > usability to the case so described. The only question is whether there
> > are applications out there which now assume min/max instead of contact
> > positions. If anyone knows, please speak up. :-) Otherwise, I am very
> > much for Daniel's case C, with Dmitry's modification.
> > 
> > In short: Use the semi-MT property, and send two suitable fingers
> > along with it.
> 
> Umm... but it is my understanding that 2 fingers will provide real
> tracking data, not bounding box, so why would we set semi-MT?

To indicate that a) the two positions may not represent true fingers
but a bounding box, and b) the contact count is determined by
BTN_TOOL_*.

True, there is no way to distinguish between the real-fingers and
bounding-box cases here (that is why I suggested another binary value
in a previous mail), but without semi-mt, there is no way to know a
priori if special logic is needed for the number of fingers.

> Maybe we have different notions of what semi-MT property conveys? For me
> semi-MT indicates that the device provides 2 coordinates for bounding
> box.  However if semi-MT is not set does not mean that the device
> provides true tracking for all contacts, but only for advertised slots.
> There still may be additional data transmitted.

Yes, it seems we do have different assumptions here. The more reason
to document it further. :-)

To me, it seems we do need a little bit of extra information to
determine this new type of device.

Thanks,
Henrik
