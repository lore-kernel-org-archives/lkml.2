Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2JBJTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:19:19 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55465 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab2JBJTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:19:17 -0400
Message-ID: <506AB0BF.9030400@parallels.com>
Date: Tue, 2 Oct 2012 13:15:43 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <devel@openvz.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 1/4] memcg: provide root figures from system totals
References: <1348563173-8952-1-git-send-email-glommer@parallels.com> <1348563173-8952-2-git-send-email-glommer@parallels.com> <20121001170046.GC24860@dhcp22.suse.cz>
In-Reply-To: <20121001170046.GC24860@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2012 09:00 PM, Michal Hocko wrote:
> On Tue 25-09-12 12:52:50, Glauber Costa wrote:
>> > For the root memcg, there is no need to rely on the res_counters.
> This is true only if there are no children groups but once there is at
> least one we have to move global statistics into root res_counter and
> start using it since then. This is a tricky part because it has to be
> done atomically so that we do not miss anything.
> 
Why can't we shortcut it all the time?

It makes a lot of sense to use the root cgroup as the sum of everything,
IOW, global counters. Otherwise you are left in a situation where you
had global statistics, and all of a sudden, when a group is created, you
start having just a subset of that, excluding the tasks in root.

If we can always assume root will have the sum of *all* tasks, including
the ones in root, we should never need to rely on root res_counters.

