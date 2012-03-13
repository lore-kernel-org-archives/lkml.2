Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2CMF2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:28:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47536 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2CMF2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:28:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Mar 2012 14:26:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <jweiner@redhat.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4.5/7] mm: optimize isolate_lru_pages()
Message-Id: <20120313142635.a6a7b806.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120311141334.29756.79407.stgit@zurg>
References: <20120308175752.27621.54781.stgit@zurg>
	<20120311141334.29756.79407.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 18:36:16 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch moves lru checks from __isolate_lru_page() to its callers.
> 
> They aren't required on non-lumpy reclaim: all pages are came from right lru.
> Pages isolation on memory compaction should skip only unevictable pages.
> Thus we need to check page lru only on pages isolation for lumpy-reclaim.
> 
> Plus this patch kills mem_cgroup_lru_del() and uses mem_cgroup_lru_del_list()
> instead, because now we already have lru list index.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> add/remove: 0/1 grow/shrink: 2/1 up/down: 101/-164 (-63)
> function                                     old     new   delta
> static.isolate_lru_pages                    1018    1103     +85
> compact_zone                                2230    2246     +16
> mem_cgroup_lru_del                            65       -     -65
> __isolate_lru_page                           287     188     -99


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


