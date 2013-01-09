Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3AIVzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:55:25 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41096 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab3AIVzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:55:20 -0500
Date: Wed, 9 Jan 2013 13:55:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Glauber Costa <glommer@parallels.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] Add mempressure cgroup
Message-ID: <20130109215514.GD20454@htj.dyndns.org>
References: <20130104082751.GA22227@lizard.gateway.2wire.net>
 <1357288152-23625-1-git-send-email-anton.vorontsov@linaro.org>
 <20130109203731.GA20454@htj.dyndns.org>
 <50EDDF1E.6010705@parallels.com>
 <20130109213604.GA9475@lizard.fhda.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109213604.GA9475@lizard.fhda.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Anton.

On Wed, Jan 09, 2013 at 01:36:04PM -0800, Anton Vorontsov wrote:
> On Thu, Jan 10, 2013 at 01:20:30AM +0400, Glauber Costa wrote:
> [...]
> > Given the above, I believe that ideally we should use this pressure
> > mechanism in memcg replacing the current memcg notification mechanism.
> 
> Just a quick wonder: why would we need to place it into memcg, when we
> don't need any of the memcg stuff for it? I see no benefits, not
> design-wise, not implementation-wise or anything-wise. :)

Maybe I'm misunderstanding the whole thing but how can memory pressure
exist apart from memcg when memcg is in use?  Memory limits, reclaim
and OOM are all per-memcg, how do you even define memory pressure?  If
ten tasks belong to a memcg w/ a lot of spare memory and one belongs
to another which is about to hit OOM, is that mempressure cgroup under
pressure?

> We can use mempressure w/o memcg, and even then it can (or should :) be
> useful (for cpuset, for example).

The problem is that you end with, at the very least, duplicate
hierarchical accounting mechanisms which overlap with each other
while, most likely, being slightly different.  About the same thing
happened with cpu and cpuacct controllers and we're now trying to
deprecate the latter.

Please talk with memcg people and fold it into memcg.  It can (and
should) be done in a way to not incur overhead when only root memcg is
in use and how this is done defines userland-visible interface, so
let's please not repeat past mistakes.

Thanks.

-- 
tejun
