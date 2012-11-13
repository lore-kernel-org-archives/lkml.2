Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2KMXyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:54:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33153 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2KMXya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:54:30 -0500
Date: Tue, 13 Nov 2012 15:54:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andy Lutomirski <luto@amacapital.net>, Marc Duponcheel <marc@offline.be>
cc: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [3.6 regression?] THP + migration/compaction livelock (I
 think)
In-Reply-To: <CALCETrXSzNEdNEZaQqB93rpP9zXcBD4KRX_bjTAnzU6JEXcApg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1211131553170.17623@chino.kir.corp.google.com>
References: <CALCETrVgbx-8Ex1Q6YgEYv-Oxjoa1oprpsQE-Ww6iuwf7jFeGg@mail.gmail.com> <alpine.DEB.2.00.1211131507370.17623@chino.kir.corp.google.com> <CALCETrU=7+pk_rMKKuzgW1gafWfv6v7eQtVw3p8JryaTkyVQYQ@mail.gmail.com> <alpine.DEB.2.00.1211131530020.17623@chino.kir.corp.google.com>
 <CALCETrXSzNEdNEZaQqB93rpP9zXcBD4KRX_bjTAnzU6JEXcApg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Andy Lutomirski wrote:

> >> $ grep -E "compact_|thp_" /proc/vmstat
> >> compact_blocks_moved 8332448774
> >> compact_pages_moved 21831286
> >> compact_pagemigrate_failed 211260
> >> compact_stall 13484
> >> compact_fail 6717
> >> compact_success 6755
> >> thp_fault_alloc 150665
> >> thp_fault_fallback 4270
> >> thp_collapse_alloc 19771
> >> thp_collapse_alloc_failed 2188
> >> thp_split 19600
> >>
> >
> > Two of the patches from the list provided at
> > http://marc.info/?l=linux-mm&m=135179005510688 are already in your 3.6.3
> > kernel:
> >
> >         mm: compaction: abort compaction loop if lock is contended or run too long
> >         mm: compaction: acquire the zone->lock as late as possible
> >
> > and all have not made it to the 3.6 stable kernel yet, so would it be
> > possible to try with 3.7-rc5 to see if it fixes the issue?  If so, it will
> > indicate that the entire series is a candidate to backport to 3.6.
> 
> I'll try later on.  The last time I tried to boot 3.7 on this box, it
> failed impressively (presumably due to a localmodconfig bug, but I
> haven't tracked it down yet).
> 
> I'm also not sure how reliably I can reproduce this.
> 

The challenge goes out to Marc too since he reported this issue on 3.6.2 
but we haven't heard back yet on the success of the backport (although 
it's probably easier to try 3.7-rc5 since there are some conflicts to 
resolve).
