Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0KLJh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:37:58 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57211 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab0KLJh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:37:56 -0500
Date: Fri, 12 Nov 2010 09:37:43 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm,vmscan: Reclaim order-0 and compact instead of
	lumpy reclaim when under light pressure
Message-ID: <20101112093742.GA3537@csn.ul.ie>
References: <1289502424-12661-1-git-send-email-mel@csn.ul.ie> <1289502424-12661-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1289502424-12661-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 07:07:04PM +0000, Mel Gorman wrote:
> +	if (COMPACTION_BUILD)
> +		sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
> +	else
> +		sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
>  

Gack, I posted the slightly wrong version. This version prevents lumpy
reclaim ever being used. The figures I posted were for a patch where
this condition looked like

        if (COMPACTION_BUILD && priority > DEF_PRIORITY - 2)
                sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
        else
                sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
