Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab1B0VKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:10:07 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46256 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1B0VKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:10:04 -0500
Date: Sun, 27 Feb 2011 22:09:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] memcg: clean up migration
Message-ID: <20110227210951.GZ25382@cmpxchg.org>
References: <1298821765-3167-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298821765-3167-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 12:49:25AM +0900, Minchan Kim wrote:
> This patch cleans up unncessary BUG_ON check and confusing
> charge variable.
> 
> That's because memcg charge/uncharge could be handled by
> mem_cgroup_[prepare/end] migration itself so charge local variable
> in unmap_and_move lost the role since we introduced 01b1ae63c2.
> 
> And mem_cgroup_prepare_migratio return 0 if only it is successful.
> Otherwise, it jumps to unlock label to clean up so BUG_ON(charge)
> isn;t meaningless.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, Minchan!

	Hannes

PS: Btw, people sometimes refer to commits by hashes from trees other
than Linus's, so it's nice to include the subject as well:

	01b1ae6 memcg: simple migration handling

You get this easily by taking the first line of

	git show --oneline <commithash>

though there are probably other ways.
