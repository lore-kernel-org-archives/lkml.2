Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2CUEos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:44:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2CUEor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:44:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F695C3F.3000406@jp.fujitsu.com>
Date: Wed, 21 Mar 2012 13:42:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 06/10] cgroup: convert memcg controller to the new cftype
 interface
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-7-git-send-email-tj@kernel.org> <4F66B55A.8020307@jp.fujitsu.com> <20120319161052.GC11069@google.com>
In-Reply-To: <20120319161052.GC11069@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/20 1:10), Tejun Heo wrote:

> Hello,
> 
> On Mon, Mar 19, 2012 at 01:26:02PM +0900, KAMEZAWA Hiroyuki wrote:
>>> +CGROUP_SUBSYS_CFTYPES_COND(mem_cgroup_subsys, memsw_cgroup_files,
>>> +			   really_do_swap_account);
>>
>>
>> I'm sorry but why you use really_do_swap_account instead of do_swap_account ?
> 
> Because do_swap_account is initialized too late.
> CGROUP_SUBSYS_CFTYPES() are processed via fs_initcall().  AFAICS,
> do_swap_account may not have been initialized by then.  Also, if memcg
> as whole is disabled, it doesn't matter whether those files are
> registered or not, right?  We probably need some comment there tho.
> 


I think creating file based on really_do_swap_account is wrong.
(I'm sorry for this complication.)

How about creating this file unconditionally ? Returning -ENOTSUP in memcg's
handler will work well...anyway it's configured, no reason to show them is bad.

Thanks,
-Kame

