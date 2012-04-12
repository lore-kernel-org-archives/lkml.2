Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616Ab2DLMdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:33:20 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50032 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab2DLMdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:33:18 -0400
Date: Thu, 12 Apr 2012 14:32:56 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120412123256.GI1787@cmpxchg.org>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F862851.3040208@jp.fujitsu.com>
 <20120412113217.GB11455@somewhere.redhat.com>
 <4F86BFC6.2050400@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F86BFC6.2050400@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 08:43:02AM -0300, Glauber Costa wrote:
> On 04/12/2012 08:32 AM, Frederic Weisbecker wrote:
> >>But I think increasing number of subsystem is not very good....
> >If the result is a better granularity on the overhead, I believe this
> >can be a good thing.
> 
> But again, since there is quite number of people trying to merge
> those stuff together, you are just swimming against the tide.

I don't see where merging unrelated controllers together is being
discussed, do you have a reference?

> If this gets really integrated, out of a sudden the overhead will
> appear. So better care about it now.

Forcing people that want to account/limit one resource to take the hit
for something else they are not interested in requires justification.
You can optimize only so much, in the end, the hierarchical accounting
is just expensive and unacceptable if you don't care about a certain
resource.  For that reason, I think controllers should stay opt-in.

Btw, can we please have a discussion where raised concerns are
supported by more than gut feeling?  "I think X is not very good" is
hardly an argument.  Where is the technical problem in increasing the
number of available controllers?
