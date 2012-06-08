Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762025Ab2FHJMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:12:55 -0400
Received: from smtp.nokia.com ([147.243.128.26]:24000 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759622Ab2FHJMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:12:54 -0400
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>, <minchan@kernel.org>
CC: <anton.vorontsov@linaro.org>, <kosaki.motohiro@gmail.com>,
        <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: RE: [PATCH 0/5] Some vmevent fixes...
Thread-Topic: [PATCH 0/5] Some vmevent fixes...
Thread-Index: AQHNP/FOitsSrN1KnkOrXYpeZEkA+pboy3gAgADvzACAADBdAIAAjZ+AgADEMwCAAA6MAIACwKmAgAHoSgCAAA8ogIAAAVQAgAAlvNA=
Date: Fri, 8 Jun 2012 09:12:36 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045F7B42@008-AM1MPN1-004.mgdnok.nokia.com>
References: <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<20120601122118.GA6128@lizard>
	<alpine.LFD.2.02.1206032125320.1943@tux.localdomain>
	<4FCC7592.9030403@kernel.org>	<20120604113811.GA4291@lizard>
	<4FCD14F1.1030105@gmail.com>
	<CAOJsxLHR4wSgT2hNfOB=X6ud0rXgYg+h7PTHzAZYCUdLs6Ktug@mail.gmail.com>
	<20120605083921.GA21745@lizard>	<4FD014D7.6000605@kernel.org>
	<20120608074906.GA27095@lizard>	<4FD1BB29.1050805@kernel.org>
 <CAOJsxLHPvg=bsv+GakFGHyJwH0BoGA=fmzy5bwqWKNGryYTDtg@mail.gmail.com>
In-Reply-To: <CAOJsxLHPvg=bsv+GakFGHyJwH0BoGA=fmzy5bwqWKNGryYTDtg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.0.61]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jun 2012 09:12:37.0687 (UTC) FILETIME=[D92F4470:01CD4556]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 08 June, 2012 11:48
> To: Minchan Kim
...
> 
> On Fri, Jun 8, 2012 at 11:43 AM, Minchan Kim <minchan@kernel.org> wrote:
> >> So, the solution would be then two-fold:
> >>
> >> 1. Use your memory pressure notifications. They must be quite fast
> >> when
> >>    we starting to feel the high pressure. (I see the you use
> >>    zone_page_state() and friends, which is vm_stat, and it is updated
> >
> > VM has other information like nr_reclaimed, nr_scanned, nr_congested,
> > recent_scanned, recent_rotated, too. I hope we can make math by them
> > and improve as we improve VM reclaimer.
> >
> >>    very infrequently, but to get accurate notification we have to
> >>    update it much more frequently, but this is very expensive. So
> >>    KOSAKI and Christoph will complain. :-)
> >
> >
> > Reclaimer already have used that and if we need accuracy, we handled
> > it like zone_watermark_ok_safe. If it's very inaccurate, VM should be fixed,
> too.
> 
> Exactly. I don't know why people think pushing vmevents to userspace is
> going to fix any of the hard problems.
> 
> Anton, Lenoid, do you see any fundamental issues from userspace point of
> view with going forward what Minchan is proposing?

That good proposal but I have to underline that userspace could be interested not only in memory consumption stressed cases (pressure, vm watermarks ON etc.) 
but quite relaxed as well e.g. 60% durty pages are consumed - let's do not restart some daemons. In very stressed conditions user-space might be already dead.

Another interesting question which combination of VM page types could be recognized as interesting for tracking as Minchan correctly stated it depends from area.
For me seems weights most likely will be -1, 0 or +1 to calculate resulting values and thesholds e.g. Active = {+1 * Active_Anon; +1 * Active_File}
It will extend flexibility a lot.
