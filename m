Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0ICGdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 02:33:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51964 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0ICGdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 02:33:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmscan: don't use return value trick when oom_killer_disabled
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org
In-Reply-To: <AANLkTinNZYQ7WV_xu7_WE-ekPhHOjqsfr9xtnW3m9r1V@mail.gmail.com>
References: <201009022204.14661.rjw@sisk.pl> <AANLkTinNZYQ7WV_xu7_WE-ekPhHOjqsfr9xtnW3m9r1V@mail.gmail.com>
Message-Id: <20100903153234.3FCB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  3 Sep 2010 15:33:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/9/3 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Thursday, September 02, 2010, Minchan Kim wrote:
> >> M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
> >> 32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
> >> Also he was bisected first bad commit is below
> >>
> >>   commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
> >>   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> >>   Date:   Fri Jun 4 14:15:05 2010 -0700
> >>
> >>      vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
> >>
> >> At first impression, this seemed very strange because the above commit only
> >> chenged function return value and hibernate_preallocate_memory() ignore
> >> return value of shrink_all_memory(). But it's related.
> >>
> >> Now, page allocation from hibernation code may enter infinite loop if
> >> the system has highmem.
> >>
> >> The reasons are two. 1) hibernate_preallocate_memory() call
> >> alloc_pages() wrong order
> >
> > This isn't the case, as explained here: http://lkml.org/lkml/2010/9/1/316 .
> >
> > The ordering of calls is correct, but it's better to check if there are any
> > non-highmem pages to allocate from before the last call (for performance
> > reasons, but that also would eliminate the failure in question).
> 
> I actually didn't look into the 1) problem detail.
> Just copy and paste from KOSAKI's description.
> As I look the thread, KOSAKI seem to admit the description is wrong.
> I will resend the patch removing phrase about 1) problem if KOSAKI don't mind.
> KOSAKI. Is it okay?

Yeah! please :)




