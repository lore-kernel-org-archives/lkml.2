Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1KXAOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:14:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54078 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1KXAOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:14:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:13:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: memcg: modify PageCgroupCache non-atomically
Message-Id: <20111124091328.d28d9f55.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322062951-1756-9-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-9-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 16:42:31 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> This bit is protected by lock_page_cgroup(), there is no need for
> locked operations when setting and clearing it.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

Hm. non-atomic ops for pc->flags seems dangerous.
How about try to remove PCG_CACHE ? Maybe we can depends on PageAnon(page).
We see 'page' on memcg->lru now.
I'm sorry I forgot why we needed PCG_CACHE flag..

Thanks,
-Kame

