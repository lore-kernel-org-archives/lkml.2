Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1AUA2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:28:37 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37408 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1AUA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:28:36 -0500
Message-id: <isapiwc.d5d1bc27.4ba4.4d38d17e.d73ba.1d@mail.jp.nec.com>
In-Reply-To: <20110121083930.d803126f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110118113528.fd24928f.kamezawa.hiroyu@jp.fujitsu.com>
 <20110118114348.9e1dba9b.kamezawa.hiroyu@jp.fujitsu.com>
 <20110120134108.GO2232@cmpxchg.org>
 <20110121083930.d803126f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 21 Jan 2011 09:21:18 +0900
From: nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 4/4] memcg: fix rmdir, force_empty with THP
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > @@ -2278,17 +2287,23 @@ static int mem_cgroup_move_parent(struct
>> >  		goto out;
>> >  	if (isolate_lru_page(page))
>> >  		goto put;
>> > +	/* The page is isolated from LRU and we have no race with splitting */
>> > +	charge = PAGE_SIZE << compound_order(page);
>> 
>> Why is LRU isolation preventing the splitting?
>> 
Oops! It seems that this comment made me confuse 'split' and 'collapse'.
Yes, it's 'collapse', not 'split', that is prevented by isolation.

> I use compound_lock now. I'll post clean up.
> 
I'll wait for your patch.

Thanks,
Daisuke Nishimura.
