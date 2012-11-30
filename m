Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834Ab2K3PhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:37:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030753Ab2K3PhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:37:17 -0500
Date: Fri, 30 Nov 2012 16:37:15 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121130153715.GK29317@dhcp22.suse.cz>
References: <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130150347.GJ29317@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130150347.GJ29317@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 16:03:47, Michal Hocko wrote:
[...]
> Anyway, the more interesting thing is gfp_mask is GFP_NOWAIT allocation
> from the page fault? Huh this shouldn't happen - ever.

OK, it starts making sense now. The message came from
pagefault_out_of_memory which doesn't have gfp nor the required node
information any longer. This suggests that VM_FAULT_OOM has been
returned by the fault handler. So this hasn't been triggered by the page
fault allocator.
I am wondering whether this could be caused by the patch but the effect
of that one should be limitted to the write (unlike the later version
for -mm tree which hooks into the shmem as well).

Will have to think about it some more.
-- 
Michal Hocko
SUSE Labs
