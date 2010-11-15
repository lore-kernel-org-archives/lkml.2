Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab0KOA1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 19:27:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56452 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0KOA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 19:27:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] cleanup kswapd()
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1011141202430.3460@swampdragon.chaosbits.net>
References: <20101114180505.BEE2.A69D9226@jp.fujitsu.com> <alpine.LNX.2.00.1011141202430.3460@swampdragon.chaosbits.net>
Message-Id: <20101115092712.BEF4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Nov 2010 09:27:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 14 Nov 2010, KOSAKI Motohiro wrote:
> 
> > 
> > Currently, kswapd() function has deeper nest and it slightly harder to
> > read. cleanup it.
> > 
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/vmscan.c |   71 +++++++++++++++++++++++++++++++---------------------------
> >  1 files changed, 38 insertions(+), 33 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 8cc90d5..82ffe5f 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2364,6 +2364,42 @@ out:
> >  	return sc.nr_reclaimed;
> >  }
> >  
> > +void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
> 
> Shouldn't this be
> 
>   static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
> 
> ??

Right. thank you.
I'll respin.




