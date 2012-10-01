Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2JAIq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:46:59 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50806 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab2JAIq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:46:57 -0400
Message-ID: <506957AC.5070206@parallels.com>
Date: Mon, 1 Oct 2012 12:43:24 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <20120927142822.GG3429@suse.de> <20120927144942.GB4251@mtj.dyndns.org> <50646977.40300@parallels.com> <20120927174605.GA2713@localhost> <50649EAD.2050306@parallels.com> <20120930075700.GE10383@mtj.dyndns.org> <20120930080249.GF10383@mtj.dyndns.org> <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com> <20120930103732.GK10383@mtj.dyndns.org> <1349004352.2458.34.camel@dabdike.int.hansenpartnership.com> <20121001005717.GM10383@mtj.dyndns.org>
In-Reply-To: <20121001005717.GM10383@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 04:57 AM, Tejun Heo wrote:
> Hello, James.
> 
> On Sun, Sep 30, 2012 at 12:25:52PM +0100, James Bottomley wrote:
>> But you've got to ask yourself who cares about accurate accounting per
>> container of dentry and inode objects? They're not objects that any
>> administrator is used to limiting.  What we at parallels care about
>> isn't accurately accounting them, it's that one container can't DoS
>> another by exhausting system resources.  That's achieved equally well by
>> first charge slab accounting, so we don't really have an interest in
>> pushing object accounting code for which there's no use case.
> 
> Isn't it more because the use cases you have on mind don't share
> dentries/inodes too much?  Wildly incorrect accounting definitely
> degrades container isolation and can lead to unexpected behaviors.
> 
>> All we need kernel memory accounting and limiting for is DoS prevention.
>> There aren't really any system administrators who care about Kernel
>> Memory accounting (at least until the system goes oom) because there are
>> no absolute knobs for it (all there is are a set of weird and wonderful
>> heuristics, like dirty limit ratio and drop caches).  Kernel memory
> 
> I think that's because the mechanism currently doesn't exist.  If one
> wants to control how memory is distributed across different cgroups,
> it's logical to control kernel memory too.  The resource in question
> is the actual memory after all.  I think at least google would be
> interested in it, so, no, I don't agree that nobody wants it.  If that
> is the case, we're working towards the wrong direction.
> 
>> usage has a whole set of regulatory infrastructure for trying to make it
>> transparent to the user.
>>
>> Don't get me wrong: if there were some easy way to get proper memory
>> accounting for free, we'd be happy but, because it has no practical
>> application for any of our customers, there's a limited price we're
>> willing to pay to get it.
> 
> Even on purely technical ground, it could be that first-use is the
> right trade off if other more accurate approaches are too difficult
> and most workloads are happy with such approach.  I'm still a bit
> weary to base userland interface decisions on that tho.
> 

For the record, user memory also suffers a bit from being always
constrained to first-touch accounting. Greg Thelen is working on
alternative solutions to make first-accounting the default in a
configurable environment, as he explained in the kernel summit.

When that happens, kernel memory can take advantage of it for free.

