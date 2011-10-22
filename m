Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1JVGVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 02:21:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63579 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1JVGVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 02:21:50 -0400
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Sat, 22 Oct 2011 14:21:23 +0800
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic-pae; KDE/4.6.5; i686; ; )
Cc: Hugh Dickins <hughd@google.com>, arekm@pld-linux.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, jpiszcz@lucidpixels.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <201110122012.33767.pluto@agmk.net> <CAPQyPG4SE8DyzuqwG74sE2zuZbDgfDoGDir1xHC3zdED+k=qLA@mail.gmail.com> <201110212336.47267.pluto@agmk.net>
In-Reply-To: <201110212336.47267.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110221421.23181.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 October 2011 05:36:46 Paweł Sikora wrote:
> On Friday 21 of October 2011 11:07:56 Nai Xia wrote:
> > On Fri, Oct 21, 2011 at 4:07 PM, Pawel Sikora <pluto@agmk.net> wrote:
> > > On Friday 21 of October 2011 14:22:37 Nai Xia wrote:
> > >
> > >> And as a side note. Since I notice that Pawel's workload may include OOM,
> > >
> > > my last tests on patched (3.0.4 + migrate.c fix + vserver) kernel produce full cpu load
> > > on dual 8-cores opterons like on this htop screenshot -> http://pluto.agmk.net/kernel/screen1.png
> > > afaics all userspace applications usualy don't use more than half of physical memory
> > > and so called "cache" on htop bar doesn't reach the 100%.
> > 
> > OK，did you logged any OOM killing if there was some memory usage burst?
> > But, well my above OOM reasoning is a direct short cut to imagined
> > root cause of "adjacent VMAs which
> > should have been merged but in fact not merged" case.
> > Maybe there are other cases that can lead to this or maybe it's
> > totally another bug....
> 
> i don't see any OOM killing with my conservative settings
> (vm.overcommit_memory=2, vm.overcommit_ratio=100).

OK, that does not matter now. Andrea showed us a simpler way to goto
this bug. 

> 
> > But still I think if my reasoning is good, similar bad things will
> > happen again some time in the future,
> > even if it was not your case here...
> > 
> > >
> > > the patched kernel with disabled CONFIG_TRANSPARENT_HUGEPAGE (new thing in 2.6.38)
> > > died at night, so now i'm going to disable also CONFIG_COMPACTION/MIGRATION in next
> > > steps and stress this machine again...
> > 
> > OK, it's smart to narrow down the range first....
> 
> disabling hugepage/compacting didn't help but disabling hugepage/compacting/migration keeps
> opterons stable for ~9h so far. userspace uses ~40GB (from 64) ram, caches reach 100% on htop bar,
> average load ~16. i wonder if it survive weekend...
> 

Maybe you should give another shot of Andrea's latest anon_vma_order_tail() patch. :)

