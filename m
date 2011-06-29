Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1F2KPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:15:11 -0400
Received: from iota.hadesian.co.uk ([93.93.131.154]:38620 "EHLO
	iota.hadesian.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1F2KPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:15:07 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 06:15:07 EDT
Date: Wed, 29 Jun 2011 11:07:59 +0100
From: Daniel Stone <daniel@fooishbar.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: djkurtz@chromium.org, dmitry.torokhov@gmail.com, rydberg@euromail.se,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 10/12] Input: synaptics - decode AGM packet types
Message-ID: <20110629100759.GE2403@fooishbar.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-11-git-send-email-djkurtz@chromium.org>
 <4E0AF84D.6050702@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0AF84D.6050702@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Wed, Jun 29, 2011 at 11:02:53AM +0100, Chase Douglas wrote:
> In the older "profile" devices, we got essentially the bounding box of
> all touches. This allows us to detect pinch gestures between the two
> most extreme touches when there are three touches on the touchpad.

This isn't necessarily true for all pads.  If you look at Derek's
patchset from a couple of weeks ago, it was for a profile sensor which
had the same reporting behaviour.  Internally, the touchpad could track
many fingers, but would always report the first (in SGM packet) and most
recent (in AGM packet) fingers.  You could fake a bounding-box
calculation, but it would be the bounding box of fingers 0 and n, rather
than the bounding box of all fingers.

> The above description makes it sound like we will no longer have a
> bounding box of touches. According to the description, if I put four
> fingers down in a square formation and then touch a fifth finger in the
> middle of the square, I will only see the locations of one corner and
> the middle of the square. This would make meaningful gesture detection
> beyond two touches nearly impossible. Is this really how the touchpad
> works, or is the above description not quite right?

Yes, I believe that's how the touchpad works.  It would be nice to get
all fingers, but unfortunately PS/2 doesn't give us enough bandwidth to
do that.

Cheers,
Daniel
