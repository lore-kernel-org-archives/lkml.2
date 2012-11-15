Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768085Ab2KOOrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:47:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44936 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992479Ab2KOOrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:47:37 -0500
Date: Thu, 15 Nov 2012 06:47:32 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115144732.GB7306@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
 <20121114185245.GF21185@mtj.dyndns.org>
 <20121115095103.GB11990@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115095103.GB11990@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Nov 15, 2012 at 10:51:03AM +0100, Michal Hocko wrote:
> > I'm a bit confused.  Why would that make any difference?  Shouldn't it
> > be just able to test the condition and continue?
> 
> Ohh, I misunderstood your proposal. So what you are suggesting is
> to put all the logic we have in mem_cgroup_iter inside what you call
> reclaim here + mem_cgroup_iter_break inside the loop, right?
> 
> I do not see how this would help us much. mem_cgroup_iter is not the
> nicest piece of code but it handles quite a complex requirements that we
> have currently (css reference count, multiple reclaimers racing). So I
> would rather keep it this way. Further simplifications are welcome of
> course.
> 
> Is there any reason why you are not happy about direct using of
> cgroup_next_descendant_pre?

Because I'd like to consider the next functions as implementation
detail, and having interations structred as loops tend to read better
and less error-prone.  e.g. when you use next functions directly, it's
way easier to circumvent locking requirements in a way which isn't
very obvious.  So, unless it messes up the code too much (and I can't
see why it would), I'd much prefer if memcg used for_each_*() macros.

Thanks.

-- 
tejun
