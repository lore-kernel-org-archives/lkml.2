Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1D0EWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 00:22:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43912 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1D0EWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 00:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=myPOXHqAZrgCtCF2bbYJyeQ8JzeUQQwULi3rfClWwE7oO7SwAVmVb9DMnPJLnFecvK
         /qM9KhRuvnJ5zVGsg6/zX5UmIaiL2Pc8K0csgIaHOgpfK/VMyrQNNcfaw1efkUev8d0f
         yY70nbml1W+/oRgcpcVuUQzhLDmXIfinW8Xw4=
MIME-Version: 1.0
In-Reply-To: <b7bcce639e9b9bf515431cda79b15d482f889ff2.1303833418.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<b7bcce639e9b9bf515431cda79b15d482f889ff2.1303833418.git.minchan.kim@gmail.com>
Date: Wed, 27 Apr 2011 13:22:37 +0900
Message-ID: <BANLkTincwtuon1nk8C3q6+CFHhQx-ZXVNQ@mail.gmail.com>
Subject: Re: [RFC 8/8] compaction: make compaction use in-order putback
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have add up this piece.
I will resend all after work.

===

diff --git a/mm/compaction.c b/mm/compaction.c
index 95af5bc..59a675c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c

@@ -327,7 +328,7 @@ static unsigned long isolate_migratepages(struct zone *zone,

                /* Successfully isolated */
                del_page_from_lru_list(zone, page, page_lru(page));
-               list_add(&page->lru, migratelist);
+               list_add(&pages_lru->lru, migratelist);
                cc->nr_migratepages++;
                nr_isolated++;
@@ -525,7 +525,7 @@ static int compact_zone(struct zone *zone, struct
compact_control *cc)
                nr_migrate = cc->nr_migratepages;
                migrate_pages(&cc->migratepages, compaction_alloc,
                                (unsigned long)cc, false,
-                               cc->sync, false);
+                               cc->sync, true);
                count_vm_event(PGMIGRATE);
                update_nr_listpages(cc);
                nr_remaining = cc->nr_migratepages;

==
-- 
Kind regards,
Minchan Kim
