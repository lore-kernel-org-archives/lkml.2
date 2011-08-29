Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1H2QJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:09:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab1H2QJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:09:56 -0400
Date: Mon, 29 Aug 2011 18:08:39 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Balbir Singh <bsingharora@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 1/2] mm: vmscan: fix force-scanning small targets without
 swap
Message-ID: <20110829160839.GA22439@redhat.com>
References: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313094715-31187-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Aug 11, 2011 at 10:31:54PM +0200, Johannes Weiner wrote:
> Without swap, anonymous pages are not scanned.  As such, they should
> not count when considering force-scanning a small target if there is
> no swap.
> 
> Otherwise, targets are not force-scanned even when their effective
> scan number is zero and the other conditions--kswapd/memcg--apply.

I forgot to mention, this patch is a fix for '246e87a memcg: fix
get_scan_count() for small targets', which went upstream this merge
window.

Probably makes sense to merge this one too before the release..?

Sorry.
