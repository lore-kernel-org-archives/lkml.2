Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1IZLwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:52:20 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44338 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1IZLwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:52:19 -0400
MIME-Version: 1.0
Date: Mon, 26 Sep 2011 17:21:12 +0530
Message-ID: <CAFPAmTRHFOT+tc=J-=jTBpvi8ksnp6H32UsEwptrrv=hagjUsA@mail.gmail.com>
Subject: Why isn't shrink_slab more zone oriented ?
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was going through the do_try_to_free_pages(), balance_pgdat(),
__zone_reclaim()
functions and I see that shrink_zone and shrink_slab are called for each zone.

But, shrink_slab() doesn't seem to bother about the zone from where it
is freeing
memory.

My questions are:

- Will this be a strain on the direct/indirect reclamation algorithm ?
  The loops involved expects to free something from that particular zone.
  shrink_slab might take more time than is required to free up pages from that
  particular zone which might not be optimal.
  Am I right about this conclusion ?

- If the above is correct, then is there any work happening on this
front, i.e., to
  make shrink_slab functionality and the shrinker callbacks more zone-centric ?
  Are there any patches that I could look at or download from
somewhere for this ?

- Are there any other considerations to be careful of for making
shrink_slab more
  zone centric ? Can there be other side effects that affects
performance if the
  shrink_slab and shrinker callbacks are made to free pages only from
a particular
  zone ?

Thanks,
Kautuk.
