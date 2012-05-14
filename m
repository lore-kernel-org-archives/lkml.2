Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2ENSRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:17:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36299 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2ENSRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:17:30 -0400
Date: Mon, 14 May 2012 11:17:25 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] add res_counter_uncharge_until()
Message-ID: <20120514181725.GF2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACE01A.4040405@jp.fujitsu.com>
 <20120511141945.c487e94c.akpm@linux-foundation.org>
 <4FB05B8F.8020408@jp.fujitsu.com>
 <CAFTL4hwGEhyxZO0sXx5gVyK_xjhMQEbHojJbHzQmVKafNyVWtw@mail.gmail.com>
 <4FB0DF4A.5010506@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB0DF4A.5010506@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 07:32:42PM +0900, KAMEZAWA Hiroyuki wrote:
> [PATCH 2/6] memcg: add res_counter_uncharge_until()
> 
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> At killing res_counter which is a child of other counter,
> we need to do
> 	res_counter_uncharge(child, xxx)
> 	res_counter_charge(parent, xxx)
> 
> This is not atomic and wasting cpu. This patch adds
> res_counter_uncharge_until(). This function's uncharge propagates
> to ancestors until specified res_counter.
> 
> 	res_counter_uncharge_until(child, parent, xxx)
> 
> Now, ops is atomic and efficient.
> 
> Changelog since v2
>  - removed unnecessary lines.
>  - added 'From' , this patch comes from his one.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
