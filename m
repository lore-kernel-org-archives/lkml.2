Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1I1Ewb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 00:52:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33672 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1I1Ewa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 00:52:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 13:51:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@google.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: disable user interface to manually rescue
 unevictable pages
Message-Id: <20110928135138.5113bc30.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110927072714.GA1997@redhat.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
	<20110926112944.GC14333@redhat.com>
	<20110926161136.b4508ecb.akpm@google.com>
	<20110927072714.GA1997@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 09:27:14 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> At one point, anonymous pages were supposed to go on the unevictable
> list when no swap space was configured, and the idea was to manually
> rescue those pages after adding swap and making them evictable again.
> But nowadays, swap-backed pages on the anon LRU list are not scanned
> without available swap space anyway, so there is no point in moving
> them to a separate list anymore.
> 
> The manual rescue could also be used in case pages were stranded on
> the unevictable list due to race conditions.  But the code has been
> around for a while now and newly discovered bugs should be properly
> reported and dealt with instead of relying on such a manual fixup.
> 
> In addition to the lack of a usecase, the sysfs interface to rescue
> pages from a specific NUMA node has been broken since its
> introduction, so it's unlikely that anybody ever relied on that.
> 
> This patch removes the functionality behind the sysctl and the
> node-interface and emits a one-time warning when somebody tries to
> access either of them.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Reported-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

