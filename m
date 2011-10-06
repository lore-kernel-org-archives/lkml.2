Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1JFDmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 23:42:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42430 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1JFDmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 23:42:12 -0400
Date: Wed, 5 Oct 2011 20:42:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chasedouglas@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Daniel Kurtz <djkurtz@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: evdev - use monotonic clock for event timestamps
Message-ID: <20111006034202.GC20217@core.coreip.homeip.net>
References: <1317624200-9762-1-git-send-email-djkurtz@chromium.org>
 <20111003090641.GA5615@polaris.bitmath.org>
 <CAGS+omAj9z2-Au2HABtDKHQGRBNVxXygF2cz+L8UMeTHRrMjbA@mail.gmail.com>
 <20111005092341.GB6840@polaris.bitmath.org>
 <4E8C6B1F.4090904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8C6B1F.4090904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:35:11PM +0100, Chase Douglas wrote:
> On 10/05/2011 10:23 AM, Henrik Rydberg wrote:
> >> I understand your concern about breaking random drivers, and am hoping
> >> that someon on this list could indicate whether this is a real concern
> >> or not.  To get a better feeling for possible regressions, I checked
> >> xf86-input-evdev & -synaptics, and neither uses the evdev timestamp in
> >> their current incarnations.  Any idea what else might be a good place
> >> to check?
> > 
> > The input system is used for all sorts of events - switches, for
> > instance. The point is that it is nearly impossible to know if
> > something will break or not, hence the reluctance to modify interfaces.
> > 
> >> One option is to make the evdev timestamp clock source a per-driver
> >> configuration option (controllable from userspace?).  This sounds like
> >> it is doable, but would be significantly more complicated.
> >>
> >> Another option would be to timestamp with monotonicraw + boottime +
> >> sleeptime.  This would be approximately wall clock time, but without
> >> ntp and slew adjustments.  But, I fear this would just make the rare
> >> driver issue less obvious, since it would only become obvious when the
> >> two clock sources started drifting apart.
> > 
> > I agree, the problem is not really solvable. Dmitry?
> 
> We could put it into the -next tree early on in the cycle, and then it
> will be in -next for a cycle and in Linus' tree for the real dev cycle.
> By that time we would hope any issues would have emerged.

No, I do not think so - as we already descovered users of that field (if
they are exist) are pretty obscure and I doubt that they actively track
development kernels.

> 
> I'm not sure if that is a responsible approach. I agree that the change
> would be good, but how sure would we be that nothing would break based
> only on testing in development trees?
> 
> My personal thoughts are that I doubt it would cause issues. Based on
> that gut feel, I would say that this approach is reasonable. However,
> I'm just one voice in all this :).

I can see key loggers wanting to see real time of captured events
instead of monotonic time...

If we really need this I think we'll have to go per-file descriptor time
source selection and ioctl way. However can we get the use case
explained again? Why is wall clock jumps so much in middle of the
motion? Can userspace detect negative time jumps and simply abort
gestures in such cases?

Thanks.

-- 
Dmitry
