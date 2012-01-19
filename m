Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2ASLHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:07:55 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47208 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab2ASLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:07:53 -0500
MIME-Version: 1.0
In-Reply-To: <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org>
	<1326788038-29141-2-git-send-email-minchan@kernel.org>
	<CAOJsxLHGYmVNk7D9NyhRuqQDwquDuA7LtUtp-1huSn5F-GvtAg@mail.gmail.com>
	<4F15A34F.40808@redhat.com>
	<alpine.LFD.2.02.1201172044310.15303@tux.localdomain>
	<84FF21A720B0874AA94B46D76DB98269045596AE@008-AM1MPN1-003.mgdnok.nokia.com>
	<CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
	<CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
	<4F175706.8000808@redhat.com>
	<alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
	<4F17DCED.4020908@redhat.com>
	<CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
	<4F17E058.8020008@redhat.com>
	<84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
Date: Thu, 19 Jan 2012 13:07:52 +0200
X-Google-Sender-Auth: YEfKbOmpZzuZCK1Ej-4hIadl7Uc
Message-ID: <CAOJsxLHd5dCvBwV5gsraFZXh86wq7tg7uLLnevN8Pp_jGiOBbw@mail.gmail.com>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
From: Pekka Enberg <penberg@kernel.org>
To: leonid.moiseichuk@nokia.com
Cc: rhod@redhat.com, riel@redhat.com, minchan@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        mel@csn.ul.ie, rientjes@google.com, kosaki.motohiro@gmail.com,
        hannes@cmpxchg.org, mtosatti@redhat.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> From potential user point of view the proposed API has number of lacks which
> would be nice to have implemented:

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> From potential user point of view the proposed API has number of lacks which
> would be nice to have implemented:

> 1. rename this API from low_mem_pressure to something more related to
> notification and memory situation in system: memory_pressure, memnotify,
> memory_level etc. The word "low" is misleading here

The thing is called vmevent:

http://git.kernel.org/?p=linux/kernel/git/penberg/linux.git;a=shortlog;h=refs/heads/vmevent/core
[penberg@tux ~]$ vi
[penberg@tux ~]$ cat email
On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> From potential user point of view the proposed API has number of lacks which
> would be nice to have implemented:

> 1. rename this API from low_mem_pressure to something more related to
> notification and memory situation in system: memory_pressure, memnotify,
> memory_level etc. The word "low" is misleading here

The thing is called vmevent:

http://git.kernel.org/?p=linux/kernel/git/penberg/linux.git;a=shortlog;h=refs/heads/vmevent/core

I haven't used "low mem" at all in the patches.

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 2. API must use deferred timers to prevent use-time impact. Deferred timer
> will be triggered only in case HW event or non-deferrable timer, so if device
> sleeps timer might be skipped and that is what expected for user-space

I'm currently looking at the possibility of hooking VM events to perf which
also uses hrtimers. Can't we make hrtimers do the right thing?

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 3. API should be tunable for propagate changes when level is Up or Down,
> maybe both ways.

Agreed.

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 4. to avoid triggering too much events probably has sense to filter according
> to amount of change but that is optional. If subscriber set timer to 1s the
> amount of events should not be very big.

Agreed.

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 5. API must provide interface to request parameters e.g. available swap or
> free memory just to have some base.

The current ABI already supports that. You can specify which attributes you're
interested in and they will be delivered as part of th event.

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 6. I do not understand how work with attributes performed ( ) but it has
> sense to use mask and fill requested attributes using mask and callback table
> i.e. if free pages requested - they are reported, otherwise not.

That's how it works now in the git tree.

On Thu, Jan 19, 2012 at 12:53 PM,  <leonid.moiseichuk@nokia.com> wrote:
> 7. would have sense to backport couple of attributes from memnotify.c
>
> I can submit couple of patches if some of proposals looks sane for everyone.

Feel free to do that.

I'm currently looking at how to support Minchan's non-sampled events. It seems
to me integrating with perf would be nice because we could simply use
tracepoints for this.

			Pekka
