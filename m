Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0IWLot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:44:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35638 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab0IWLos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:44:48 -0400
Date: Thu, 23 Sep 2010 17:14:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: robm@fastmail.fm, linux-kernel@vger.kernel.org,
        Bron Gondwana <brong@fastmail.fm>, linux-mm <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
Message-ID: <20100923114442.GK3952@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1284349152.15254.1394658481@webmail.messagingengine.com>
 <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-09-16 19:01:32]:

> +			if (!(zone_reclaim_mode & RECLAIM_CACHE) &&
> +			    (gfp_mask & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK) {
> +				inc_zone_state(zone, NR_ZONE_CACHE_AVOID);
> +				goto try_next_zone;
> +			}
> +

Interesting approach, so for page cache related applications we expect
RECLAIM_CACHE to be set and hence zone_reclaim to occur. I have
another variation, a new gfp flag called __GFP_FREE_CACHE. You can
find the patches at

http://lwn.net/Articles/391293/
http://article.gmane.org/gmane.linux.kernel.mm/49155

-- 
	Three Cheers,
	Balbir
