Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab2DLLTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:19:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60069 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2DLLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:19:35 -0400
Date: Thu, 12 Apr 2012 13:19:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120412111925.GA11455@somewhere.redhat.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F85D9C6.5000202@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85D9C6.5000202@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 04:21:42PM -0300, Glauber Costa wrote:
> On 04/11/2012 03:57 PM, Frederic Weisbecker wrote:
> >So if we choose the second solution, this overhead will be added unconditionally
> >to memcg.
> >But I don't expect every users of memcg will need the task counter. So perhaps
> >the overhead should be kept in its own separate subsystem.
> 
> What we're usually doing with kmem paths, like the upcoming slab
> tracking, is do not account if it is not limited. So if you are not
> limited in a particular cgroup, you jut don't bother with accounting.

So that's a good point. I can start accounting tasks and apply limits
once we write to the file only.

> 
> If this suits your need, you can probably do the same, and then
> pay the price just for the users that are interested on it.
> 
> Now, whether or not this should be considered memory, is a different
> story. You can say it is memory yes, but I bet you can very well
> find a bunch of arguments to consider it "cpu" as well.
> 
> Against the memcg, consider this: Your counter would probably be the
> first non-page based data in memcg. At least raises a flag.

Good points.
