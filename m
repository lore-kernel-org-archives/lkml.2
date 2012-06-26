Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab2FZHLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:11:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42220 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2FZHLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:11:24 -0400
Message-ID: <4FE95FF0.3000300@parallels.com>
Date: Tue, 26 Jun 2012 11:08:32 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 05/11] Add a __GFP_KMEMCG flag
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252123230.26640@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206252123230.26640@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.9.3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 08:25 AM, David Rientjes wrote:
> On Mon, 25 Jun 2012, Glauber Costa wrote:
>
>> >This flag is used to indicate to the callees that this allocation will be
>> >serviced to the kernel. It is not supposed to be passed by the callers
>> >of kmem_cache_alloc, but rather by the cache core itself.
>> >
> Not sure what "serviced to the kernel" means, does this mean that the
> memory will not be accounted for to the root memcg?
>
In this context, it means that is a kernel allocation, not a userspace 
one (but in process context, of course), *and* it is to be accounted a
specific memcg.

