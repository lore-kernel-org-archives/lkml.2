Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1LIBWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:22:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33539 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1LIBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:22:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Dec 2011 10:21:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org, eric.dumazet@gmail.com, cgroups@vger.kernel.org,
        hannes@cmpxchg.org, mhocko@suse.cz, Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH v8 1/9] Basic kernel memory functionality for the Memory
 Controller
Message-Id: <20111209102113.cdb85da8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1323120903-2831-2-git-send-email-glommer@parallels.com>
References: <1323120903-2831-1-git-send-email-glommer@parallels.com>
	<1323120903-2831-2-git-send-email-glommer@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Dec 2011 19:34:55 -0200
Glauber Costa <glommer@parallels.com> wrote:

> This patch lays down the foundation for the kernel memory component
> of the Memory Controller.
> 
> As of today, I am only laying down the following files:
> 
>  * memory.independent_kmem_limit
>  * memory.kmem.limit_in_bytes (currently ignored)
>  * memory.kmem.usage_in_bytes (always zero)
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
> CC: Paul Menage <paul@paulmenage.org>
> CC: Greg Thelen <gthelen@google.com>

As I wrote, please CC Johannes and  Michal Hocko for memcg related parts.

A few questions.
==
> +	val = !!val;
> +
> +	if (parent && parent->use_hierarchy &&
> +	   (val != parent->kmem_independent_accounting))
> +		return -EINVAL;
==
Hm, why you check val != parent->kmem_independent_accounting ?

	if (parent && parent->use_hierarchy)
		return -EINVAL;
?

BTW, you didn't check this cgroup has children or not.
I think

	if (this_cgroup->use_hierarchy &&
             !list_empty(this_cgroup->childlen))
		return -EINVAL;


==
> +	/*
> +	 * TODO: We need to handle the case in which we are doing
> +	 * independent kmem accounting as authorized by our parent,
> +	 * but then our parent changes its parameter.
> +	 */
> +	cgroup_lock();
> +	memcg->kmem_independent_accounting = val;
> +	cgroup_unlock();

Do we need cgroup_lock() here ?

Thanks,
-Kame

