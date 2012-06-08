Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab2FHJqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:46:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33016 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2FHJqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:46:48 -0400
Date: Fri, 8 Jun 2012 02:45:07 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: leonid.moiseichuk@nokia.com
Cc: penberg@kernel.org, minchan@kernel.org, kosaki.motohiro@gmail.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
Message-ID: <20120608094507.GA11963@lizard>
References: <4FCC7592.9030403@kernel.org>
 <20120604113811.GA4291@lizard>
 <4FCD14F1.1030105@gmail.com>
 <CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com>
 <20120605083921.GA21745@lizard>
 <4FD014D7.6000605@kernel.org>
 <20120608074906.GA27095@lizard>
 <4FD1BB29.1050805@kernel.org>
 <CAOJsxLHPvg=bsv+GakFGHyJwH0BoGA=fmzy5bwqWKNGryYTDtg@mail.gmail.com>
 <84FF21A720B0874AA94B46D76DB98269045F7B42@008-AM1MPN1-004.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045F7B42@008-AM1MPN1-004.mgdnok.nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 09:12:36AM +0000, leonid.moiseichuk@nokia.com wrote:
[...]
> > Exactly. I don't know why people think pushing vmevents to userspace is
> > going to fix any of the hard problems.
> > 
> > Anton, Lenoid, do you see any fundamental issues from userspace point of
> > view with going forward what Minchan is proposing?
> 
> That good proposal but I have to underline that userspace could be interested not only in memory consumption stressed cases (pressure, vm watermarks ON etc.) 
> but quite relaxed as well e.g. 60% durty pages are consumed - let's do not restart some daemons. In very stressed conditions user-space might be already dead.

Indeed. Minchan's proposal is good to get notified that VM is under
stress.

But suppose some app allocates memory slowly (i.e. I scroll a large
page on my phone, and the page is rendered piece by piece). So, in
the end we're slowly but surely allocate a lot of memory. In that
case Minchan's method won't notice that it's actually time to close
some apps.

Then suppose someone calls me, the "phone" application is now
starting, but since we're out of 'easy to reclaim' pages, it takes
forever for the app to load, VM is now under huge stress, and surely
we're *now* getting notified, but alas, it is too late. Call missed.


So, it's like measuring distance, velocity and acceleration. In
Android case, among other things, we're interested in distance too!
I.e. "how much exactly 'easy to reclaim' pages left", not only
"how fast we're getting out of 'easy to reclaim' pages".

> Another interesting question which combination of VM page types could be recognized as interesting for tracking as Minchan correctly stated it depends from area.
> For me seems weights most likely will be -1, 0 or +1 to calculate resulting values and thesholds e.g. Active = {+1 * Active_Anon; +1 * Active_File}
> It will extend flexibility a lot.

Exposing VM details to the userland? No good. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
