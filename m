Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826Ab2DLQh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:37:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44470 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965806Ab2DLQhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:37:24 -0400
Message-ID: <4F87042A.2000902@parallels.com>
Date: Thu, 12 Apr 2012 13:34:50 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <20120411185715.GA4317@somewhere.redhat.com> <20120412010745.GE1787@cmpxchg.org> <20120412145507.GC11455@somewhere.redhat.com>
In-Reply-To: <20120412145507.GC11455@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 11:55 AM, Frederic Weisbecker wrote:
> I don't know how the kernel stack is allocated for tasks. Do you mean
> that we allocate a chunck of it for each new task and we could rely
> on that?
>
More than this: amount of kernel stack is really, really something 
indirect if what you want to track is # of processes. Now, Hannes made a 
fair point in his other e-mail about what is a resource and what is not.

>> >  After all, we would only restrict the number of tasks for the
>> >  resources they require
> It depends if the kernel stack can have other kind of "consumer".
>
It also depends on what you really want to achieve.
If you want to prevent fork bombs, limiting kernel stack will do just fine.

Is there anything for which you need to know exactly the number of 
processes?
