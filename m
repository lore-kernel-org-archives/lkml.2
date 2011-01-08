Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1AHJ0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 04:26:44 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:55338 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1AHJ0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 04:26:41 -0500
Date: Sat, 8 Jan 2011 10:26:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [BUGFIX][PATCH v4] memcg: fix memory migration of shmem swapcache
Message-ID: <20110108092613.GF4654@cmpxchg.org>
References: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
 <20110105115840.GD4654@cmpxchg.org>
 <20110106100923.24b1dd12.nishimura@mxp.nes.nec.co.jp>
 <AANLkTi=rp=WZa7PP4V6anU0SQ3BM-RJQwiDu1fJuoDig@mail.gmail.com>
 <20110106123415.895d6dfc.nishimura@mxp.nes.nec.co.jp>
 <20110106054200.GG3722@balbir.in.ibm.com>
 <20110106152911.db6c5b2c.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106152911.db6c5b2c.nishimura@mxp.nes.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 03:29:11PM +0900, Daisuke Nishimura wrote:
> In current implimentation, mem_cgroup_end_migration() decides whether the page
> migration has succeeded or not by checking "oldpage->mapping".
> 
> But if we are tring to migrate a shmem swapcache, the page->mapping of it is
> NULL from the begining, so the check would be invalid.
> As a result, mem_cgroup_end_migration() assumes the migration has succeeded
> even if it's not, so "newpage" would be freed while it's not uncharged.
> 
> This patch fixes it by passing mem_cgroup_end_migration() the result of the
> page migration.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
