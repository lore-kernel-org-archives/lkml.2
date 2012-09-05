Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab2IEIUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:20:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:49296 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2IEIUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:20:31 -0400
Message-ID: <50470A87.1040701@parallels.com>
Date: Wed, 5 Sep 2012 12:17:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <davej@redhat.com>, <ben@decadent.org.uk>,
        <a.p.zijlstra@chello.nl>, <pjt@google.com>, <lennart@poettering.net>,
        <kay.sievers@vrfy.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
References: <1346768300-10282-1-git-send-email-glommer@parallels.com> <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com> <5047074D.1030104@parallels.com> <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 12:14 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Sep 05, 2012 at 12:03:25PM +0400, Glauber Costa wrote:
>> The goal here is to have distributions to do it, because they tend to
>> have a well defined lifecycle management, much more than upstream. Whoever
>> sets this option, can coordinate with upstream.
> 
> Distros can just co-mount them during boot.  What's the point of the
> config options?
> 

Pretty simple. The kernel can't assume the distro did. And then we still
need to pay a stupid big price in the scheduler.

After this patchset, We can assume this. And cpuusage can totally be
derived from the cpu cgroup. Because much more than "they can comount",
we can assume they did.

>>> Also, I really don't see much point in enforcing this almost arbitrary
>>> grouping of controllers.  It doesn't simplify anything and using
>>> cpuacct in more granular way than cpu actually is one of the better
>>> justified use of multiple hierarchies.  Also, what about memcg and
>>> blkcg?  Do they *really* coincide?  Note that both blkcg and memcg
>>> involve non-trivial overhead and blkcg is essentially broken
>>> hierarchy-wise.
>>
>> Where did I mention memcg or blkcg in this patch ?
> 
> Differing hierarchies in memcg and blkcg currently is the most
> prominent case where the intersection in writeback is problematic and
> your proposed solution doesn't help one way or the other.  What's the
> point?
> 

The point is that I am focusing at one problem at a time. But FWIW, I
don't see why memcg/blkcg can't use a step just like this one in a
separate pass.

If the goal is comounting them eventually, at some point when the issues
are sorted out, just do it. Get a switch like this one, and then you
will start being able to assume a lot of things in the code. Miracles
can happen.


