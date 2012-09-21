Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2IUT7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:59:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab2IUT7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:59:34 -0400
Date: Fri, 21 Sep 2012 12:59:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 07/16] memcg: skip memcg kmem allocations in
 specified code regions
Message-ID: <20120921195929.GL7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
 <1347977530-29755-8-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347977530-29755-8-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 18, 2012 at 06:12:01PM +0400, Glauber Costa wrote:
> +static void memcg_stop_kmem_account(void)
> +{
> +	if (!current->mm)
> +		return;
> +
> +	current->memcg_kmem_skip_account++;
> +}
> +
> +static void memcg_resume_kmem_account(void)
> +{
> +	if (!current->mm)
> +		return;
> +
> +	current->memcg_kmem_skip_account--;
> +}

I can't say I'm a big fan of this approach.  If there are enough
users, maybe but can't we just annotate the affected allocations
explicitly?  Is this gonna have many more users?

Also, in general, can we please add some comments?  I know memcg code
is dearth of comments but let's please not keep it that way.

Thanks.

-- 
tejun
