Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1LSACg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 19:02:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55981 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab1LSACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 19:02:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 19 Dec 2011 09:01:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/4] memcg: simplify page cache charging.
Message-Id: <20111219090122.66024659.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111216142814.dbb77209.akpm@linux-foundation.org>
References: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
	<20111214164922.05fb4afe.kamezawa.hiroyu@jp.fujitsu.com>
	<20111216142814.dbb77209.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 14:28:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Dec 2011 16:49:22 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Because of commit ef6a3c6311, FUSE uses replace_page_cache() instead
> > of add_to_page_cache(). Then, mem_cgroup_cache_charge() is not
> > called against FUSE's pages from splice.
> 
> Speaking of ef6a3c6311 ("mm: add replace_page_cache_page() function"),
> may I pathetically remind people that it's rather inefficient?
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1109.1/00375.html
> 

IIRC, people says inefficient because it uses memcg codes for page-migration
for fixing up accounting. Now, We added replace-page-cache for memcg in
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch

So, I think the problem originally mentioned is fixed.

I'll reconsinder LRU handling optimization after things seems to be good.

Thanks,
-Kame

