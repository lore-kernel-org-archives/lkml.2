Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab1DMVIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:08:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47508 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757779Ab1DMVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:07:59 -0400
Date: Wed, 13 Apr 2011 17:07:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v3 3/4] lib, Make gen_pool memory allocator lockless
Message-ID: <20110413210757.GA11683@Krystal>
References: <1302684835-14133-1-git-send-email-ying.huang@intel.com> <1302684835-14133-4-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302684835-14133-4-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:05:42 up 141 days,  2:08,  4 users,  load average: 0.01, 0.07,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
[...]
> + * rcu_read_lock and rcu_read_unlock is not used int gen_pool_alloc,
> + * gen_pool_free, gen_pool_avail and gen_pool_size etc, because chunks
> + * are only added into pool, not deleted from pool unless the pool
> + * itself is destroyed.  If chunk will be deleted from pool,
> + * rcu_read_lock and rcu_read_unlock should be uses in these
> + * functions.

So how do you protect between pool destruction and adding chunks into
the pool ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
