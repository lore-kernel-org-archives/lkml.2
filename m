Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2JAIcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:32:05 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51909 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab2JAIcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:32:02 -0400
Message-ID: <5069542C.2020103@parallels.com>
Date: Mon, 1 Oct 2012 12:28:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-7-git-send-email-glommer@parallels.com> <20120926155108.GE15801@dhcp22.suse.cz> <5064392D.5040707@parallels.com> <20120927134432.GE29104@dhcp22.suse.cz> <50658B3B.9020303@parallels.com> <20120930082542.GH10383@mtj.dyndns.org>
In-Reply-To: <20120930082542.GH10383@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 12:25 PM, Tejun Heo wrote:
> On Fri, Sep 28, 2012 at 03:34:19PM +0400, Glauber Costa wrote:
>> On 09/27/2012 05:44 PM, Michal Hocko wrote:
>>> Anyway, I have just noticed that __mem_cgroup_try_charge does
>>> VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
>>> keep css ref count up as well.
>>
>> IIRC, css_get will prevent the cgroup directory from being removed.
>> Because some allocations are expected to outlive the cgroup, we
>> specifically don't want that.
> 
> That synchronous ref draining is going away.  Maybe we can do that
> before kmemcg?  Michal, do you have some timeframe on mind?
> 

Since you said yourself in other points in this thread that you are fine
with some page references outliving the cgroup in the case of slab, this
is a situation that comes with the code, not a situation that was
incidentally there, and we're making use of.


