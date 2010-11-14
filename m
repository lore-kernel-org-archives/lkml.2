Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0KNFnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:43:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49946 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab0KNFnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:43:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] mm,vmscan: Reclaim order-0 and compact instead of lumpy reclaim when under light pressure
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101112093742.GA3537@csn.ul.ie>
References: <1289502424-12661-4-git-send-email-mel@csn.ul.ie> <20101112093742.GA3537@csn.ul.ie>
Message-Id: <20101114144155.E01F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:43:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 11, 2010 at 07:07:04PM +0000, Mel Gorman wrote:
> > +	if (COMPACTION_BUILD)
> > +		sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
> > +	else
> > +		sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;
> >  
> 
> Gack, I posted the slightly wrong version. This version prevents lumpy
> reclaim ever being used. The figures I posted were for a patch where
> this condition looked like
> 
>         if (COMPACTION_BUILD && priority > DEF_PRIORITY - 2)
>                 sc->lumpy_reclaim_mode = LUMPY_MODE_COMPACTION;
>         else
>                 sc->lumpy_reclaim_mode = LUMPY_MODE_CONTIGRECLAIM;

In all other place, heavy reclaim detection are used folliowing.

	if (priority < DEF_PRIORITY - 2)


So, "priority >= DEF_PRIORITY - 2" is more symmetric, I think. but if you have strong
reason, I don't oppse.



