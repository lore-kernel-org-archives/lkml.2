Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab0GVLCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:02:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33695 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab0GVLCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:02:10 -0400
Date: Thu, 22 Jul 2010 12:01:54 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: [PATCH 3/7] memcg: nid and zid can be calculated from zone
Message-ID: <20100722110154.GG13117@csn.ul.ie>
References: <20100716191418.7372.A69D9226@jp.fujitsu.com> <20100716105648.GG13117@csn.ul.ie> <20100721223349.870D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100721223349.870D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 10:33:56PM +0900, KOSAKI Motohiro wrote:
> > > +static inline int zone_nid(struct zone *zone)
> > > +{
> > > +	return zone->zone_pgdat->node_id;
> > > +}
> > > +
> > 
> > hmm, adding a helper and not converting the existing users of
> > zone->zone_pgdat may be a little confusing particularly as both types of
> > usage would exist in the same file e.g. in mem_cgroup_zone_nr_pages.
> 
> I see. here is incrementa patch.
> 

Looks grand. Thanks

> From 62cf765251af257c98fc92a58215d101d200e7ef Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Tue, 20 Jul 2010 11:30:14 +0900
> Subject: [PATCH] memcg: convert to zone_nid() from bare zone->zone_pgdat->node_id
> 
> Now, we have zone_nid(). this patch convert all existing users of
> zone->zone_pgdat.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
