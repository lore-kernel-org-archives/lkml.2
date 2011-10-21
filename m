Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1JUWHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 18:07:47 -0400
Received: from mail.agmk.net ([91.192.224.71]:33239 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1JUWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 18:07:46 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Nai Xia <nai.xia@gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Fri, 21 Oct 2011 23:36:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9-00092-g8bc03e8; KDE/4.7.2; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>, arekm@pld-linux.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, jpiszcz@lucidpixels.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <201110122012.33767.pluto@agmk.net> <2109011.boM0eZ0ZTE@pawels> <CAPQyPG4SE8DyzuqwG74sE2zuZbDgfDoGDir1xHC3zdED+k=qLA@mail.gmail.com>
In-Reply-To: <CAPQyPG4SE8DyzuqwG74sE2zuZbDgfDoGDir1xHC3zdED+k=qLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201110212336.47267.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 of October 2011 11:07:56 Nai Xia wrote:
> On Fri, Oct 21, 2011 at 4:07 PM, Pawel Sikora <pluto@agmk.net> wrote:
> > On Friday 21 of October 2011 14:22:37 Nai Xia wrote:
> >
> >> And as a side note. Since I notice that Pawel's workload may include OOM,
> >
> > my last tests on patched (3.0.4 + migrate.c fix + vserver) kernel produce full cpu load
> > on dual 8-cores opterons like on this htop screenshot -> http://pluto.agmk.net/kernel/screen1.png
> > afaics all userspace applications usualy don't use more than half of physical memory
> > and so called "cache" on htop bar doesn't reach the 100%.
> 
> OK，did you logged any OOM killing if there was some memory usage burst?
> But, well my above OOM reasoning is a direct short cut to imagined
> root cause of "adjacent VMAs which
> should have been merged but in fact not merged" case.
> Maybe there are other cases that can lead to this or maybe it's
> totally another bug....

i don't see any OOM killing with my conservative settings
(vm.overcommit_memory=2, vm.overcommit_ratio=100).

> But still I think if my reasoning is good, similar bad things will
> happen again some time in the future,
> even if it was not your case here...
> 
> >
> > the patched kernel with disabled CONFIG_TRANSPARENT_HUGEPAGE (new thing in 2.6.38)
> > died at night, so now i'm going to disable also CONFIG_COMPACTION/MIGRATION in next
> > steps and stress this machine again...
> 
> OK, it's smart to narrow down the range first....

disabling hugepage/compacting didn't help but disabling hugepage/compacting/migration keeps
opterons stable for ~9h so far. userspace uses ~40GB (from 64) ram, caches reach 100% on htop bar,
average load ~16. i wonder if it survive weekend...
