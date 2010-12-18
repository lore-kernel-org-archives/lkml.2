Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab0LRRz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 12:55:27 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:43534 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab0LRRzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 12:55:25 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 18 Dec 2010 18:54:08 +0100
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/4] Input: synaptics - add multitouch packet support
Message-ID: <20101218175408.GA1709@polaris.bitmath.org>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
 <1292683981-6908-2-git-send-email-rydberg@euromail.se>
 <AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimrNrfTXGh675_8zhOg_+9+NKgOmzJq9rafyh+6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PU0yv-0007k2-6I.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PU0yv-0007k2-6I 3c45ceab5a2565680d7a94e3f3b769f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Thanks for you comments.

> > While in MT mode and two or three fingers are touching, two sets of
> > data are sent.  The first is a new format buffer with lower resolution
> > reporting of stationary finger and the second is standard data format
> > reporting movement.
> 
> We should probably update this comment and remove parts that mention
> stationary and movement.  It appears to be doing finger tracking and
> first packet is always first touch... except we are getting reports
> that clickpads/integrated button pads may not be consistently like
> this.

Yes, good point. Will update.
 
> This tracking is partly why type B protocol is being used in later patches.

The original thought was that the two points corresponded well to the
two fingers, only sometimes in the wrong order. The solution then was
to use the tracking module to order them appropriately. As it turned
out that the fingers are not followed that well after all, the whole
idea fell flat, so we resorted to only sending the bounding rectangle,
which requires no tracking.

All in all, this patchset contains enough information to resolve
jumping and clickpad issues in user space, at the same time as it
keeps compatibility with mousedev and older hardware. We know there
are still issues, but I see no real reason to postpone these changes
any further.

Thanks,
Henrik
