Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2GID3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:29:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49675 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2GID3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:29:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FFA4F76.7090901@jp.fujitsu.com>
Date: Mon, 09 Jul 2012 12:26:46 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11] mm: memcg: only check swap cache pages for repeated
 charging
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/05 9:45), Johannes Weiner wrote:
> Only anon and shmem pages in the swap cache are attempted to be
> charged multiple times, from every swap pte fault or from
> shmem_unuse().  No other pages require checking PageCgroupUsed().
> 
> Charging pages in the swap cache is also serialized by the page lock,
> and since both the try_charge and commit_charge are called under the
> same page lock section, the PageCgroupUsed() check might as well
> happen before the counter charging, let alone reclaim.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

You're right. This is SwapCache handling is done by commit d13d144309d...
I should notice this....

Thank you very much !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

