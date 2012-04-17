Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2DQQyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:54:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37814 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab2DQQyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:54:06 -0400
Message-ID: <4F8D9FC4.3080800@parallels.com>
Date: Tue, 17 Apr 2012 13:52:20 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
References: <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com> <20120412172309.GM1787@cmpxchg.org> <20120412174155.GC13069@google.com> <4F878480.60505@jp.fujitsu.com> <20120417154117.GE32402@google.com>
In-Reply-To: <20120417154117.GE32402@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [143.106.24.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> In short, I don't think it's better to have task-counting and fd-counting in memcg.
>> It's kmem, but it's more than that, I think.
>> Please provide subsys like ulimit.
>
> So, you think that while kmem would be enough to prevent fork-bombs,
> it would still make sense to limit in more traditional ways
> (ie. ulimit style object limits).  Hmmm....
>

I personally think this is namespaces business, not cgroups.
If you have a process namespace, an interface that works to limit the 
number of processes should keep working given the constraints you are 
given.

What doesn't make sense, is to create a *new* interface to limit 
something that doesn't really need to be limited, just because you
limited a similar resource before.


