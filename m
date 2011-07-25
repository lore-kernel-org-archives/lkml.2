Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1GYBY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:24:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60216 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1GYBYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:24:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 25 Jul 2011 10:16:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: do not try to drain per-cpu caches without
 pages
Message-Id: <20110725101657.21f85bf0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2f17df54db6661c39a05669d08a9e6257435b898.1311338634.git.mhocko@suse.cz>
References: <cover.1311338634.git.mhocko@suse.cz>
	<2f17df54db6661c39a05669d08a9e6257435b898.1311338634.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 09:38:00 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> drain_all_stock_async tries to optimize a work to be done on the work
> queue by excluding any work for the current CPU because it assumes that
> the context we are called from already tried to charge from that cache
> and it's failed so it must be empty already.
> While the assumption is correct we can optimize it even more by checking
> the current number of pages in the cache. This will also reduce a work
> on other CPUs with an empty stock.
> For the current CPU we can simply call drain_local_stock rather than
> deferring it to the work queue.
> 
> [KAMEZAWA Hiroyuki - use drain_local_stock for current CPU optimization]
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

