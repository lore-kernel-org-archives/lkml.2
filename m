Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1GFWdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:33:24 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:53137 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1GFWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:33:22 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArdUAMThFE5V5q1MPGdsb2JhbABTiQqfAAsBAQEBHhkNJYh6AsMCDoYpBJdJizc
X-IronPort-AV: E=Sophos;i="4.65,489,1304287200"; 
   d="scan'208";a="204475534"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 7 Jul 2011 00:35:21 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 09/12] Input: synaptics - add image sensor support
Message-ID: <20110706223521.GA4335@polaris.bitmath.org>
References: <CAGS+omDzg-xADYxKQmWy1KRhJ=n9pn9XR_HMc01xqCSDSLa5UA@mail.gmail.com>
 <20110706174503.GA5695@core.coreip.homeip.net>
 <20110706184759.GA3389@polaris.bitmath.org>
 <20110706185832.GA6086@core.coreip.homeip.net>
 <20110706193120.GA3884@polaris.bitmath.org>
 <20110706200056.GB6086@core.coreip.homeip.net>
 <20110706202049.GA4077@polaris.bitmath.org>
 <4E14D22D.8050108@canonical.com>
 <20110706213658.GA9409@core.coreip.homeip.net>
 <4E14DEA9.1060908@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14DEA9.1060908@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The evdev protocol is discrete, not continuous, so it's theoretically
> possible that one touch could end at the same time that another begins.
> IIRC, the time resolution of some MT devices makes this completely
> possible, perhaps to the point that it would be trival to make this
> happen in a few seconds of trying.
> 
> I think the MT-B protocol has only ever used tracking_id for signalling
> touch begin and touch end, where the id goes from -1 to something else
> and vice versa. Maybe the protocol could be "extended" by saying that a
> transition from one valid id to another means there is inconsistent
> touch state, but the old touch hasn't necessarily ended and the new
> touch hasn't necessarily started at this point in time.

The in-flight change of tracking id is actually part of the design; it
makes the protocol independent of sample rate. If a particular
tracking id is no longer found in any slot, that touch has ended.

> I'm not sure this is any easier than flagging these as bad devices
> because now we need to watch tracking ID changes on top of touch count
> changes. From someone who has attempted to implement semi-mt in X
> synaptics, adding more complexity here should be avoided at all cost :).

The information available in the proposition suffices to determine
what the device is. Surely the method of transferring that information
will not have any impact on the extra code required.

> > I'll ask this - how much realistically do we care about 3+ finger
> > transitions in context of these particular devices? This is a touchpad
> > so as long as basic 2 finger gestures work (zoom, pinch, 2-finger
> > scroll) with Synaptics X driver we should be fine. I do not want to add
> > all kinds of custom flags to the protocol to deal with this generation
> > of touchpads.
> 
> I've given up on trying to send semi-mt data through the proposed XInput
> 2.1 multitouch protocol. I think the best option is to send all this
> data as valuators of a single touch (a touch and not a traditional
> pointer event due to the multitouch/gesture semantics). Thus, we should
> be focusing on what is possible in the gesture realm since we have
> thrown full multiouch out the window for these devices.
> 
> With these devices we can support one touch drag, two touch pinch,
> rotate, and zoom, and 1-5 touch tap. For these to work, we need to know
> the number of touches at any given time, the locations of the two
> touches when only two touches are active, and some representative
> location for the 1 and 3-5 touch cases.

Right, and we do, so there is no problem there, is there?

> I am sitting here writing possible solutions trying to come up with sane
> ways to handle all this, but every 5 minutes I erase what I came up with
> and start over because you only see the problems once you've analysed
> every scenario. I can't see any way to cater for these devices aside
> from: handle them as single touch because they suck, or something
> similar to what has been described in the past few hours.
> 
> > It sounds to me like latest generation of Synaptocs protocol is a dud
> > and hopefully they will fix it to something more flexible in the next
> > generationof chips...
> 
> We can only hope. In the meantime, it looks like Google is pushing to
> use these devices on reference designs for Chrome OS, and big vendors
> like Dell are perfectly happy to ship Ubuntu with the 100 times worse
> (because we don't know their protocol) ALPS devices. Waiting for sanity
> to win out seems like a lost cause to me :(.

Let us bide our time and see.

Cheers,
Henrik
