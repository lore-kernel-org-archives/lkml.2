Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2IZWmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:42:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2IZWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:42:41 -0400
Date: Wed, 26 Sep 2012 15:42:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120926224235.GB10453@mtj.dyndns.org>
References: <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120926221046.GA10453@mtj.dyndns.org>
 <506381B2.2060806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506381B2.2060806@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Sep 27, 2012 at 02:29:06AM +0400, Glauber Costa wrote:
> And then what? If you want a different behavior you need to go kill all
> your services that are using memcg so you can get the behavior you want?
> And if they happen to be making a specific flag choice by design, you
> just say "you really can't run A + B together" ?
> 
> I myself think global switches are an unnecessary complication. And let
> us not talk about use_hierarchy, please. If it becomes global, it is
> going to be as part of a phase out plan anyway. The problem with that is
> not that it is global, is that it shouldn't even exist.

I would consider it more of a compatibility thing which is set during
boot and configurable by sysadmin.  Let the newer systems enable it by
default on boot and old configs / special ones disable it as
necessary.

> > Backward compatibility is covered with single switch and I really
> > don't think "you can enable limits for kernel memory anytime but we
> > don't keep track of whatever happened before it was flipped the first
> > time because the first time is always special" is a sane thing to
> > expose to userland.  Or am I misunderstanding the proposed behavior
> > again?
> 
> You do keep track. Before you switch it for the first time, it all
> belongs to the root memcg.

Well, that's really playing with words.  Limit is per cgroup and
before the limit is set for the first time, everything is accounted to
something else.  How is that keeping track?

The proposed behavior seems really crazy to me.  Do people really
think this is a good idea?

Thanks.

-- 
tejun
