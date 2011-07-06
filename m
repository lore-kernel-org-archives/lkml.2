Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1GFUSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:18:51 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:44850 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab1GFUSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:18:50 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmdcADTCFE5V5q1MPGdsb2JhbABTiQqefwsBAQEBNzKIegLDJA6GKQSXSYs3
X-IronPort-AV: E=Sophos;i="4.65,488,1304287200"; 
   d="scan'208";a="204455676"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Jul 2011 22:20:49 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706202049.GA4077@polaris.bitmath.org>
References: <1309324042-22943-10-git-send-email-djkurtz@chromium.org>
 <20110704214220.GE23915@polaris.bitmath.org>
 <CAGS+omAzKe5frVYuV2MPXBTugKD1xNZCHsaz53H+tDO7EWw8xQ@mail.gmail.com>
 <20110705192759.GA29549@polaris.bitmath.org>
 <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
 <20110706184759.GA3389@polaris.bitmath.org>
 <20110706185832.GA6086@core.coreip.homeip.net>
 <20110706193120.GA3884@polaris.bitmath.org>
 <20110706200056.GB6086@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706200056.GB6086@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This should be pretty straightforward:
> 
> 	num_fingers = calc_fingers_from_btn_tool(device); // via EVIOCGKEY
> 	num_slots = get_number_of_slots(device); // EVIOCGABS
> 	num_untracked_contacts = max(num_fingers - num_slots, 0);

Heh, I forgot we _do_ know in advance how many fingers are supported
via BTN_TOOL_*. Ok, no more issues.

> > > Maybe we have different notions of what semi-MT property conveys? For me
> > > semi-MT indicates that the device provides 2 coordinates for bounding
> > > box.  However if semi-MT is not set does not mean that the device
> > > provides true tracking for all contacts, but only for advertised slots.
> > > There still may be additional data transmitted.
> > 
> > Yes, it seems we do have different assumptions here. The more reason
> > to document it further. :-)
> 
> I'll take patches ;)

And thou shalt receive them - some day ;-)

> > To me, it seems we do need a little bit of extra information to
> > determine this new type of device.
> 
> I think we already have all we need (see above).

I concur. So, to conclude:

a) The improved synaptics behavior can be achieved by simply using
MT-B plus BTN_TOOL_*.

b) Userspace should check BTN_TOOL_* for any discrepancies between the
maximum number of available slots (always two in this case) and the
maximum number of fingers reported (BTN_TOOL_TRIPLETAP etc). Extra
actions may then be taken to support more fingers than slots.

c) The semi-mt flag is only used to signal that the two points sent
via MT-B are the corners of a bounding box.

Cheers,
Henrik
