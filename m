Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1F2Kc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:32:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34585 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1F2Kcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:32:55 -0400
Message-ID: <4E0AFF53.5090501@canonical.com>
Date: Wed, 29 Jun 2011 11:32:51 +0100
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel Stone <daniel@fooishbar.org>
CC: djkurtz@chromium.org, dmitry.torokhov@gmail.com, rydberg@euromail.se,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 10/12] Input: synaptics - decode AGM packet types
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-11-git-send-email-djkurtz@chromium.org> <4E0AF84D.6050702@canonical.com> <20110629100759.GE2403@fooishbar.org>
In-Reply-To: <20110629100759.GE2403@fooishbar.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 11:07 AM, Daniel Stone wrote:
> Hi Chase,
> 
> On Wed, Jun 29, 2011 at 11:02:53AM +0100, Chase Douglas wrote:
>> In the older "profile" devices, we got essentially the bounding box of
>> all touches. This allows us to detect pinch gestures between the two
>> most extreme touches when there are three touches on the touchpad.
> 
> This isn't necessarily true for all pads.  If you look at Derek's
> patchset from a couple of weeks ago, it was for a profile sensor which
> had the same reporting behaviour.  Internally, the touchpad could track
> many fingers, but would always report the first (in SGM packet) and most
> recent (in AGM packet) fingers.  You could fake a bounding-box
> calculation, but it would be the bounding box of fingers 0 and n, rather
> than the bounding box of all fingers.

Are we really sure that Derek's trackpad was a profile device? I mean
*really* sure. Because if Synaptics is putting out two different devices
that are identical in protocol but behave differently, then that's a
*big* problem for us gesture developers :).

I would be surprised if a profile device were providing the first and
third touch locations as opposed to the bounding box because then
there's no difference between it and this new "image sensor" device type.

>> The above description makes it sound like we will no longer have a
>> bounding box of touches. According to the description, if I put four
>> fingers down in a square formation and then touch a fifth finger in the
>> middle of the square, I will only see the locations of one corner and
>> the middle of the square. This would make meaningful gesture detection
>> beyond two touches nearly impossible. Is this really how the touchpad
>> works, or is the above description not quite right?
> 
> Yes, I believe that's how the touchpad works.  It would be nice to get
> all fingers, but unfortunately PS/2 doesn't give us enough bandwidth to
> do that.

If this is true for these new image devices, then we'll need to set a
different property bit other than SEMI_MT (maybe FIRST_LAST_MT? I'm not
good with names :). I'm thinking we should disable gesture support for
these trackpads in uTouch when there are more than two touches because
we can't be sure what is going on in any meaningful way. The bounding
box is more useful than this, which is really sad.

-- Chase
