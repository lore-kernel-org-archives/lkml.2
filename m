Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1HaOmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:42:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48604 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1HaOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:42:00 -0400
Date: Wed, 31 Aug 2011 23:41:50 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3] compaction: compact unevictable page
Message-ID: <20110831144150.GA1860@barrios-desktop>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <8ef02605a7a76b176167d90a285033afa8513326.1321112552.git.minchan.kim@gmail.com>
 <20110831111954.GB17512@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831111954.GB17512@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 01:19:54PM +0200, Johannes Weiner wrote:
> On Sun, Nov 13, 2011 at 01:37:42AM +0900, Minchan Kim wrote:
> > Now compaction doesn't handle mlocked page as it uses __isolate_lru_page
> > which doesn't consider unevicatable page. It has been used by just lumpy so
> > it was pointless that it isolates unevictable page. But the situation is
> > changed. Compaction could handle unevictable page and it can help getting
> > big contiguos pages in fragment memory by many pinned page with mlock.
> 
> This may result in applications unexpectedly faulting and waiting on
> mlocked pages under migration.  I wonder how realtime people feel
> about that?

I didn't consider it but it's very important point.
The migrate_page can call pageout on dirty page so RT process could wait on the
mlocked page during very long time.
I can mitigate it with isolating mlocked page in case of !sync but still we can't
guarantee the time because we can't know how many vmas point the page so that try_to_unmap
could spend lots of time.

We can think it's a trade off between high order allocation VS RT latency.
Now I am biasing toward RT latency as considering mlock man page.

Any thoughts?

-- 
Kind regards,
Minchan Kim
