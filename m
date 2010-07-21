Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0GUNea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:34:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47105 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0GUNe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:34:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100716102557.GE13117@csn.ul.ie>
References: <20100716191256.736C.A69D9226@jp.fujitsu.com> <20100716102557.GE13117@csn.ul.ie>
Message-Id: <20100721223414.8713.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 21 Jul 2010 22:34:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jul 16, 2010 at 07:13:31PM +0900, KOSAKI Motohiro wrote:
> > Currently, mem_cgroup_shrink_node_zone() initialize sc.nr_to_reclaim as 0.
> > It mean shrink_zone() only scan 32 pages and immediately return even if
> > it doesn't reclaim any pages.
> > 
> 
> Do you mean it immediately returns once one page is reclaimed? i.e. this
> check
> 
>                if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
>                         break;

Strictly speaking, once SWAP_CLUSTER_MAX batch is scanned. no need
to reclaim pages at all.



