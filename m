Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab2DKTX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:23:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40651 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977Ab2DKTXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:23:23 -0400
Message-ID: <4F85D9C6.5000202@parallels.com>
Date: Wed, 11 Apr 2012 16:21:42 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com>
In-Reply-To: <20120411185715.GA4317@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 03:57 PM, Frederic Weisbecker wrote:
> So if we choose the second solution, this overhead will be added unconditionally
> to memcg.
> But I don't expect every users of memcg will need the task counter. So perhaps
> the overhead should be kept in its own separate subsystem.

What we're usually doing with kmem paths, like the upcoming slab 
tracking, is do not account if it is not limited. So if you are not
limited in a particular cgroup, you jut don't bother with accounting.

If this suits your need, you can probably do the same, and then
pay the price just for the users that are interested on it.

Now, whether or not this should be considered memory, is a different 
story. You can say it is memory yes, but I bet you can very well find a 
bunch of arguments to consider it "cpu" as well.

Against the memcg, consider this: Your counter would probably be the 
first non-page based data in memcg. At least raises a flag.
