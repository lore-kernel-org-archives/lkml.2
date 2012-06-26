Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2FZPc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:32:29 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48441 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757161Ab2FZPc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:32:28 -0400
Message-ID: <4FE9D568.4050802@parallels.com>
Date: Tue, 26 Jun 2012 19:29:44 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <20120625161720.ae13ae90.akpm@linux-foundation.org>
In-Reply-To: <20120625161720.ae13ae90.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 03:17 AM, Andrew Morton wrote:
>> +	if (ret == -EINTR)  {
>> >+		nofail = true;
>> >+		/*
>> >+		 * __mem_cgroup_try_charge() chose to bypass to root due
>> >+		 * to OOM kill or fatal signal.
> Is "bypass" correct?  Maybe "fall back"?
>

Heh, forgot this one, sorry =(

__mem_cgroup_try_charge does "goto bypass", so I believe the term
"bypass" is better to allow whoever is following this code to follow it.

