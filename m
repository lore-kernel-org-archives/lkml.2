Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab2FZSAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:00:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2FZSAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:00:41 -0400
Date: Tue, 26 Jun 2012 11:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
Message-Id: <20120626110142.b7cf6d7c.akpm@linux-foundation.org>
In-Reply-To: <4FE9CEBB.80108@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
	<1340633728-12785-7-git-send-email-glommer@parallels.com>
	<20120625161720.ae13ae90.akpm@linux-foundation.org>
	<4FE9CEBB.80108@parallels.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012 19:01:15 +0400 Glauber Costa <glommer@parallels.com> wrote:

> On 06/26/2012 03:17 AM, Andrew Morton wrote:
> >> +	memcg_uncharge_kmem(memcg, size);
> >> >+	mem_cgroup_put(memcg);
> >> >+}
> >> >+EXPORT_SYMBOL(__mem_cgroup_free_kmem_page);
> >> >  #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
> >> >
> >> >  #if defined(CONFIG_INET) && defined(CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
> >> >@@ -5645,3 +5751,69 @@ static int __init enable_swap_account(char *s)
> >> >  __setup("swapaccount=", enable_swap_account);
> >> >
> >> >  #endif
> >> >+
> >> >+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> > gargh.  CONFIG_MEMCG_KMEM, please!
> >
> 
> Here too. I like it as much as you do.
> 
> But that is consistent with the rest of the file, and I'd rather have
> it this way.

There's not much point in being consistent with something which is so
unpleasant.  I'm on a little campaign to rename
CONFIG_CGROUP_MEM_RES_CTLR to CONFIG_MEMCG, only nobody has taken my
bait yet.  Be first!

