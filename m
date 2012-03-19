Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab2CSKo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:44:58 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40627 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab2CSKo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:44:56 -0400
Message-ID: <4F670DC2.1030904@parallels.com>
Date: Mon, 19 Mar 2012 14:43:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, <lizf@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <fweisbec@gmail.com>, <rni@google.com>,
        <ctalbott@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new cftype
 interface
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-7-git-send-email-tj@kernel.org> <4F66B55A.8020307@jp.fujitsu.com>
In-Reply-To: <4F66B55A.8020307@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 08:26 AM, KAMEZAWA Hiroyuki wrote:
>> ->populate() is preserved for register_kmem_files() invocation but I
>> >  strongly urge moving the initialization to the tail of ->create().  If
>> >  there's something which can't be done from ->create(), which isn't
>> >  clear from the comment, please let me know.
>> >  
> Okay, then, cgroup files are created in kernel/cgroup.c and memcg just
> registers entries.
> 
> 
> 
I am still in the middle of the review. Is it possible to dynamically
register entries? (right now, I mean)

If yes - which seems to be a bit of the point of the exercise, so it
should be totally okay from my PoV. I have that call in populate because
which files will be created depends on which protocols you have registered.

The trick here, is that doesn't need to happen at all cgroup creations.
But it can't happen at root's either, because this is quite fragile:
some protocols may only be registered after root memcg is created.
