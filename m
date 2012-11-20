Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2KTG1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:27:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58448 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2KTG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:27:12 -0500
Date: Mon, 19 Nov 2012 22:24:00 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC 3/3] man-pages: Add man page for vmpressure_fd(2)
Message-ID: <20121120062400.GA9468@lizard>
References: <20121107105348.GA25549@lizard>
 <20121107110152.GC30462@lizard>
 <20121119215211.6370ac3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121119215211.6370ac3b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 09:52:11PM -0800, Andrew Morton wrote:
> On Wed, 7 Nov 2012 03:01:52 -0800 Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> >        Upon  these  notifications,  userland programs can cooperate with
> >        the kernel, achieving better system's memory management.
> 
> Well I read through the whole thread and afaict the above is the only
> attempt to describe why this patchset exists!

Thanks for taking a look. :)

> How about we step away from implementation details for a while and
> discuss observed problems, use-cases, requirements and such?  What are
> we actually trying to achieve here?

We try to make userland freeing resources when the system becomes low on
memory. Once we're short on memory, sometimes it's better to discard
(free) data, rather than let the kernel to drain file caches or even start
swapping.

In Android case, the data includes all idling applications' state, some of
which might be saved on the disk anyway -- so we don't need to swap apps,
we just kill them. Another Android use-case is to kill low-priority tasks
(e.g. currently unimportant services -- background/sync daemons, etc.).

There are other use cases: VPS/containers balancing, freeing browser's old
pages renders on desktops, etc. But I'll let folks speak for their use
cases, as I truly know about Android/embedded only.

But in general, it's the same stuff as the in-kernel shrinker, except that
we try to make it available for the userland: the userland knows better
about its memory, so we want to let it help with the memory management.

Thanks,
Anton.
