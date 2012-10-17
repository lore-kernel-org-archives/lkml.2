Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2JQWM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:12:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2JQWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:12:22 -0400
Date: Wed, 17 Oct 2012 15:12:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 07/14] mm: Allocate kernel pages to the right memcg
Message-Id: <20121017151221.4c420e5a.akpm@linux-foundation.org>
In-Reply-To: <1350382611-20579-8-git-send-email-glommer@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
	<1350382611-20579-8-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 14:16:44 +0400
Glauber Costa <glommer@parallels.com> wrote:

> When a process tries to allocate a page with the __GFP_KMEMCG flag, the
> page allocator will call the corresponding memcg functions to validate
> the allocation. Tasks in the root memcg can always proceed.
> 
> To avoid adding markers to the page - and a kmem flag that would
> necessarily follow, as much as doing page_cgroup lookups for no reason,
> whoever is marking its allocations with __GFP_KMEMCG flag is responsible
> for telling the page allocator that this is such an allocation at
> free_pages() time.

Well, why?  Was that the correct decision?

> This is done by the invocation of
> __free_accounted_pages() and free_accounted_pages().

These are very general-sounding names.  I'd expect the identifiers to
contain "memcg" and/or "kmem", to identify what's going on.

