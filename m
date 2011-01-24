Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1AXKUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:20:07 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:41633 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1AXKUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:20:05 -0500
Date: Mon, 24 Jan 2011 11:19:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/7] memcg : remove ugly vairable initialization by
 callers
Message-ID: <20110124101955.GV2232@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110121155051.0b309b1f.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121155051.0b309b1f.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 03:50:51PM +0900, KAMEZAWA Hiroyuki wrote:
> This is a promised one.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch is for removing initialization in caller of memory cgroup
> function. Some memory cgroup uses following style to bring the result
> of start function to the end function for avoiding races.
> 
>    mem_cgroup_start_A(&(*ptr))
>    /* Something very complicated can happen here. */
>    mem_cgroup_end_A(*ptr)
> 
> In some calls, *ptr should be initialized to NULL be caller. But
> it's ugly. This patch fixes that *ptr is initialized by _start
> function.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Nitpick: I would remove the comments above the *ptr = NULL lines,
there should be no assumptions about the consequences in the caller
(the next patch will change the caller, and then the comments are
nothing but confusing).  It's just a plain initialization of a return
value.
