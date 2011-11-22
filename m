Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1KVJvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:51:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1KVJvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:51:46 -0500
Date: Tue, 22 Nov 2011 09:51:42 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm: compaction: avoid overwork in migrate sync mode
Message-ID: <20111122095142.GI19415@suse.de>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
 <1321732460-14155-6-git-send-email-aarcange@redhat.com>
 <4ECAC9C8.5040202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4ECAC9C8.5040202@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 04:59:36PM -0500, Rik van Riel wrote:
> On 11/19/2011 02:54 PM, Andrea Arcangeli wrote:
> >Add a lightweight sync migration (sync == 2) mode that avoids overwork
> >so more suitable to be used by compaction to provide lower latency but
> 
> >--- a/mm/compaction.c
> >+++ b/mm/compaction.c
> >@@ -552,7 +552,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
> >  		nr_migrate = cc->nr_migratepages;
> >  		err = migrate_pages(&cc->migratepages, compaction_alloc,
> >  				(unsigned long)cc, false,
> >-				cc->sync);
> >+				cc->sync ? 2 : 0);
> 
> Great idea, but it would be good if these numbers got
> a symbolic name so people trying to learn the code can
> figure it out a little easier.
> 

I took the bulk of this patch and gave them symbolic names when trying
to reconcile the two series. I didn't take all this patch such as
varying the number of passes because even if that turns out to be of
benefit, it should be a separate patch.

-- 
Mel Gorman
SUSE Labs
