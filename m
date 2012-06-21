Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab2FUUUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:20:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54191 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760164Ab2FUUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:20:48 -0400
Date: Thu, 21 Jun 2012 13:20:43 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Message-ID: <20120621202043.GD4642@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACDED0.3020400@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 06:41:36PM +0900, KAMEZAWA Hiroyuki wrote:
> Hi, here is v3 based on memcg-devel tree.
> git://github.com/mstsxfx/memcg-devel.git
> 
> This patch series is for avoiding -ENOMEM at calling pre_destroy() 
> which is called at rmdir(). After this patch, charges will be moved
> to root (if use_hierarchy==0) or parent (if use_hierarchy==1), and
> we'll not see -ENOMEM in rmdir() of cgroup.
> 
> v2 included some other patches than ones for handling -ENOMEM problem,
> but I divided it. I'd like to post others in different series, later.
> No logical changes in general, maybe v3 is cleaner than v2.
> 
> 0001 ....fix error code in memcg-hugetlb
> 0002 ....add res_counter_uncharge_until
> 0003 ....use res_counter_uncharge_until in memcg
> 0004 ....move charges to root is use_hierarchy==0
> 0005 ....cleanup for mem_cgroup_move_account()
> 0006 ....remove warning of res_counter_uncharge_nofail (from Costa's slub accounting series).

KAME, how is this progressing?  Is it stuck on anything?

Thank you very much.

-- 
tejun
