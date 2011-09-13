Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1IMKIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:08:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41542 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1IMKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:08:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:07:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 02/11] mm: vmscan: distinguish global reclaim from
 global LRU scanning
Message-Id: <20110913190749.c56d3f90.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-3-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-3-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:19 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> The traditional zone reclaim code is scanning the per-zone LRU lists
> during direct reclaim and kswapd, and the per-zone per-memory cgroup
> LRU lists when reclaiming on behalf of a memory cgroup limit.
> 
> Subsequent patches will convert the traditional reclaim code to
> reclaim exclusively from the per-memory cgroup LRU lists.  As a
> result, using the predicate for which LRU list is scanned will no
> longer be appropriate to tell global reclaim from limit reclaim.
> 
> This patch adds a global_reclaim() predicate to tell direct/kswapd
> reclaim from memory cgroup limit reclaim and substitutes it in all
> places where currently scanning_global_lru() is used for that.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

