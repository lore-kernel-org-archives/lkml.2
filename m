Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161891Ab2CSQPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:15:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39089 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161633Ab2CSQPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:15:12 -0400
Date: Mon, 19 Mar 2012 09:15:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new
 cftype interface
Message-ID: <20120319161507.GD11069@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-7-git-send-email-tj@kernel.org>
 <4F66B55A.8020307@jp.fujitsu.com>
 <4F670DC2.1030904@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F670DC2.1030904@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Mar 19, 2012 at 02:43:14PM +0400, Glauber Costa wrote:
> I am still in the middle of the review. Is it possible to dynamically
> register entries? (right now, I mean)

Before the patchset, no.  After the patchset, yes.

> If yes - which seems to be a bit of the point of the exercise, so it
> should be totally okay from my PoV. I have that call in populate because
> which files will be created depends on which protocols you have registered.
> 
> The trick here, is that doesn't need to happen at all cgroup creations.
> But it can't happen at root's either, because this is quite fragile:
> some protocols may only be registered after root memcg is created.

Yeah, it can happen anytime but it shouldn't be called from ->create()
or other callbacks which are invoked under cgroup_mutex.  We can
provide an alternative interface or other locking trickery to avoid
this, but I don't think I'll take that path unless there are very
strong rationale.

Thanks.

-- 
tejun
