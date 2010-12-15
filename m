Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0LOXmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:42:37 -0500
Received: from leo.clearchain.com ([199.73.29.74]:43001 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab0LOXmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:42:36 -0500
Date: Thu, 16 Dec 2010 09:42:29 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
Message-ID: <20101215234228.GA4694@salty.local>
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
 <4D06A7B1.6060609@canonical.com>
 <4D06A90C.90009@euromail.se>
 <4D07E38C.4020201@canonical.com>
 <4D08CEE8.9080804@euromail.se>
 <4D08FF4F.1020307@canonical.com>
 <AANLkTikM5dXSv2onvF5aqzqkEuwrvbS5DTeE0CiW91j3@mail.gmail.com>
 <4D093218.8040707@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D093218.8040707@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 16 Dec 2010 10:12:35 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:24:40PM -0500, Chase Douglas wrote:
> > Is this custom code or in upstream (are you talking about
> > inside_active_area logic?)?  I'm not sure why your seeing a jump if
> > its being discarded.  There is a chance that something related to this
> > discard logic is defeating the other logic that handles jumps caused
> > during finger transitions.
> 
> In Ubuntu 10.10 I think we are using an in-house patched hack. It was
> necessary for an Dell Minis, which was a paid OEM services project, so
> we needed a fix ASAP at the time. I believe xf86-input-synaptics has an
> option for this now, so we'll probably transition whenever someone gets
> a chance to take another look. It may be something that would be handled
> better by the upstream logic. When I get a chance I'll try the upstream
> logic instead.

mostly identical logic, but the Ubuntu patches only covered the bottom edge
(MovementBottomEdge option, IIRC). The upstream version covers all four
edges with AreaLeftEdge and friends.
recent X servers also support a percentage as option, so instead of the
hardcoded value for the edge, you can say Option "AreaBottomEdge" "20%"

I've had a few attempts to fix this touchpad to work slighlty better but
the box died on me before I could finish it. Feel free to send me one of
these machines if you want it fixed, it's been bugging me for ages :)

Cheers,
  Peter
