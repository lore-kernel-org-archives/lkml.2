Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0CWS10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:27:26 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:45912 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0CWS1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:27:24 -0400
Date: Tue, 23 Mar 2010 13:25:47 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 08/11] Add /proc trigger for memory compaction
In-Reply-To: <1269347146-7461-9-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003231323410.10178@router.home>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-9-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010, Mel Gorman wrote:

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 0d2e8aa..faa9b53 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -346,3 +347,63 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>  	return ret;
>  }
>
> +/* Compact all zones within a node */
> +static int compact_node(int nid)
> +{
> +	int zoneid;
> +	pg_data_t *pgdat;
> +	struct zone *zone;
> +
> +	if (nid < 0 || nid > nr_node_ids || !node_online(nid))

Must be nid >= nr_node_ids.

Otherwise

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

