Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2ENUJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:09:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56703 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab2ENUJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:09:30 -0400
Date: Mon, 14 May 2012 13:09:25 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] remove __must_check for
 res_counter_charge_nofail()
Message-ID: <20120514200925.GH2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE184.6020307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACE184.6020307@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 06:53:08PM +0900, KAMEZAWA Hiroyuki wrote:
> I picked this up from Costa's slub memcg series. For fixing added warning
> by patch 4.
> ==
> From: Glauber Costa <glommer@parallels.com>
> Subject: [PATCH 6/6] remove __must_check for res_counter_charge_nofail()
> 
> Since we will succeed with the allocation no matter what, there
> isn't the need to use __must_check with it. It can very well
> be optional.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

For 3-6,

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks a lot for doing this.  This doesn't solve all the failure paths
tho.  ie. what about -EINTR failures from lock contention?
pre_destroy() would probably need delay and retry logic with
WARN_ON_ONCE() on !-EINTR failures.

Thank you.

-- 
tejun
