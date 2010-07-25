Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0GYJsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 05:48:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43305 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0GYJsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 05:48:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <AANLkTikpZ8iH1oO1k84kvo2qYYS96LYuNmmw6xJL-1QV@mail.gmail.com>
References: <20100723154638.88C8.A69D9226@jp.fujitsu.com> <AANLkTikpZ8iH1oO1k84kvo2qYYS96LYuNmmw6xJL-1QV@mail.gmail.com>
Message-Id: <20100725184322.40CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 25 Jul 2010 18:48:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> 1. How far does this push pages (in terms of when limit is hit)?
> >
> > 32 pages per mem_cgroup_shrink_node_zone().
> >
> > That said, the algorithm is here.
> >
> > 1. call mem_cgroup_largest_soft_limit_node()
> >   calculate largest cgroup
> > 2. call mem_cgroup_shrink_node_zone() and shrink 32 pages
> > 3. goto 1 if limit is still exceed.
> >
> > If it's not your intention, can you please your intended algorithm?
> 
> We set it to 0, since we care only about a single page reclaim on
> hitting the limit. IIRC, in the past we saw an excessive pushback on
> reclaiming SWAP_CLUSTER_MAX pages, just wanted to check if you are
> seeing the same behaviour even now after your changes.

Actually, we have 32 pages reclaim batch size. (see nr_scan_try_batch() and related functions)
thus <32 value doesn't works as your intended.

But, If you run your test again, and (if there is) report any bugs. I'm very glad and fix it soon.

Thanks.



