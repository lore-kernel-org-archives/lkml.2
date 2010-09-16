Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab0IPHWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:22:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49377 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0IPHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:22:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Sep 2010 16:17:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH][-mm] memcg : memory cgroup cpu hotplug support update.
Message-Id: <20100916161727.04a1f905.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100916152204.6c457936.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100916144618.852b7e9a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100916062159.GF22371@balbir.in.ibm.com>
	<20100916152204.6c457936.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 15:22:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
 
> This naming is from mem_cgroup_walk_tree(). Now we have
> 
>   mem_cgroup_walk_tree();
>   mem_cgroup_walk_all();
> 
> Rename both ? But it should be in separated patch.
> 

Considering a bit ...but..

#define for_each_mem_cgroup(mem) \
	for (mem = mem_cgroup_get_first(); \
	     mem; \
	     mem = mem_cgroup_get_next(mem);) \

seems to need some helper functions. I'll consider about this clean up
but it requires some amount of patch because css_get()/css_put()/rcu...etc..
are problematic.

Thanks,
-Kame

