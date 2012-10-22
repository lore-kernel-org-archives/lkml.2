Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab2JVHsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:48:18 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36740 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab2JVHsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:48:15 -0400
Message-ID: <5084FA31.4060709@parallels.com>
Date: Mon, 22 Oct 2012 11:48:01 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 16/18] slab: propagate tunables values
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-17-git-send-email-glommer@parallels.com> <0000013a7a94c439-825659cc-8e6a-4905-909c-db1b230a4086-000000@email.amazonses.com>
In-Reply-To: <0000013a7a94c439-825659cc-8e6a-4905-909c-db1b230a4086-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:51 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> SLAB allows us to tune a particular cache behavior with tunables.
>> When creating a new memcg cache copy, we'd like to preserve any tunables
>> the parent cache already had.
> 
> SLAB and SLUB allow tuning. Could you come up with some way to put these
> things into slab common and make it flexible so that the tuning could be
> used for future allocators (like SLAM etc)?
> 
They do, but they also do it very differently. Like slub uses sysfs,
while slab don't.

I of course fully support the integration, I just don't think this
should be a blocker for all kinds of work in the allocators. Converting
slab to sysfs seems to be a major work, that you are already tackling.
Were it simple, I believe it would be done already. Without it, this is
pretty much a fake integration...

In summary, adding this doesn't make the integration work any harder in
the future, and blocking this particular thing on sysfs integration is
unreasonable.

This being by far not central to the patchset, if this is an absolute
requirement, maybe I should just drop it for the time being so it
doesn't stall the rest of the development.



