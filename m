Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1IMKmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:42:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59800 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1IMKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:42:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Sep 2011 19:41:50 +0900
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
Subject: Re: [patch 08/11] mm: vmscan: convert global reclaim to per-memcg
 LRU lists
Message-Id: <20110913194150.ce66b655.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315825048-3437-9-git-send-email-jweiner@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
	<1315825048-3437-9-git-send-email-jweiner@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011 12:57:25 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> The global per-zone LRU lists are about to go away on memcg-enabled
> kernels, global reclaim must be able to find its pages on the
> per-memcg LRU lists.
> 
> Since the LRU pages of a zone are distributed over all existing memory
> cgroups, a scan target for a zone is complete when all memory cgroups
> are scanned for their proportional share of a zone's memory.
> 
> The forced scanning of small scan targets from kswapd is limited to
> zones marked unreclaimable, otherwise kswapd can quickly overreclaim
> by force-scanning the LRU lists of multiple memory cgroups.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

