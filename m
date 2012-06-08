Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab2FHIIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:08:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49594 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760311Ab2FHIIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:08:46 -0400
Date: Fri, 8 Jun 2012 01:07:05 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred work
Message-ID: <20120608080704.GB6362@lizard>
References: <20120601122118.GA6128@lizard>
 <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com>
 <20120608065828.GA1515@lizard>
 <CAOJsxLEOsTC9mLo12dEpeatkgKq0xHjZXhGcO7Z99JHs3-D=9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOJsxLEOsTC9mLo12dEpeatkgKq0xHjZXhGcO7Z99JHs3-D=9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 10:03:24AM +0300, Pekka Enberg wrote:
> On Fri, Jun 8, 2012 at 9:58 AM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > If you're saying that we should set up a timer in the userland and
> > constantly read /proc/vmstat, then we will cause CPU wake up
> > every 100ms, which is not acceptable. Well, we can try to introduce
> > deferrable timers for the userspace. But then it would still add
> > a lot more overhead for our task, as this solution adds other two
> > context switches to read and parse /proc/vmstat. I guess this is
> > not a show-stopper though, so we can discuss this.
> >
> > Leonid, Pekka, what do you think about the idea?
> 
> That's exactly the kind of half-assed ABI that lead to people
> inventing out-of-tree lowmem notifiers in the first place.

:-)

Well, at least powersaving-wise, the solution w/ userland deferred
timers would be much better then just looping over /proc/vmstat each
100ms, and it is comparable to vmevent. Not pretty, but still would
work.

> I'd be more interested to know what people think of Minchan's that
> gets rid of vmstat sampling.

I answered to Minchan's post. The thing is that Minchan's idea
is not a substitution for vmevent. To me it seems like a shrinker w/
some pre-filter.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
