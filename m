Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031856Ab2CSQLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:11:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44736 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab2CSQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:10:58 -0400
Date: Mon, 19 Mar 2012 09:10:52 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new
 cftype interface
Message-ID: <20120319161052.GC11069@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-7-git-send-email-tj@kernel.org>
 <4F66B55A.8020307@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F66B55A.8020307@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 19, 2012 at 01:26:02PM +0900, KAMEZAWA Hiroyuki wrote:
> > +CGROUP_SUBSYS_CFTYPES_COND(mem_cgroup_subsys, memsw_cgroup_files,
> > +			   really_do_swap_account);
> 
> 
> I'm sorry but why you use really_do_swap_account instead of do_swap_account ?

Because do_swap_account is initialized too late.
CGROUP_SUBSYS_CFTYPES() are processed via fs_initcall().  AFAICS,
do_swap_account may not have been initialized by then.  Also, if memcg
as whole is disabled, it doesn't matter whether those files are
registered or not, right?  We probably need some comment there tho.

Thanks.

-- 
tejun
