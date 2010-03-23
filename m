Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0CWScs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:32:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43928 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0CWScr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:32:47 -0400
Date: Tue, 23 Mar 2010 18:32:28 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 08/11] Add /proc trigger for memory compaction
Message-ID: <20100323183228.GE5870@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-9-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003231323410.10178@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003231323410.10178@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 01:25:47PM -0500, Christoph Lameter wrote:
> On Tue, 23 Mar 2010, Mel Gorman wrote:
> 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 0d2e8aa..faa9b53 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -346,3 +347,63 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
> >  	return ret;
> >  }
> >
> > +/* Compact all zones within a node */
> > +static int compact_node(int nid)
> > +{
> > +	int zoneid;
> > +	pg_data_t *pgdat;
> > +	struct zone *zone;
> > +
> > +	if (nid < 0 || nid > nr_node_ids || !node_online(nid))
> 
> Must be nid >= nr_node_ids.
> 

Oops, correct. It should be "impossible" to supply an incorrect nid here
but still.

> Otherwise
> 
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> 

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
