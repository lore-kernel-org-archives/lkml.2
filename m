Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1KXAKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:10:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53924 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab1KXAKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:10:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:09:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] mm: memcg: modify PageCgroupAcctLRU non-atomically
Message-Id: <20111124090915.2f6e2e2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 16:42:30 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> From: Johannes Weiner <jweiner@redhat.com>
> 
> This bit is protected by zone->lru_lock, there is no need for locked
> operations when setting and clearing it.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

This atomic ops are for avoiding race with other ops as lock_page_cgroup().
Or other Set/ClearPageCgroup....

Do I misunderstand atomic ops v.s. non-atomic ops race ?

Thanks,
-Kame

