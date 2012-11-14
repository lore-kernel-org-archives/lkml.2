Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423165Ab2KNSaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:30:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51305 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423016Ab2KNSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:30:13 -0500
Date: Wed, 14 Nov 2012 10:30:07 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC] rework mem_cgroup iterator
Message-ID: <20121114183007.GC21185@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <50A2F9FC.5050303@huawei.com>
 <20121114083653.GA17111@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114083653.GA17111@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Nov 14, 2012 at 09:36:53AM +0100, Michal Hocko wrote:
> > So memcg won't use css id at all, right?
> 
> Unfortunately we still use it for the swap accounting but that one could
> be replaced by something else, probably. Have to think about it.

I have a patch to add cgrp->id pending.  From what I can see, memcg
should be able to use that for swap accounting.

> > Then we can remove the whole css_id stuff, and that's quite a bunch of
> > code.

Yeap, that's the plan.

> Is memcg the only user of css_id? Quick grep shows that yes but I
> haven't checked all the callers of the exported functions. I would be
> happy if more code goes away.

Yeap, memcg is the only user and I really wanna remove it once memcg
moves onto saner stuff.

Thanks.

-- 
tejun
