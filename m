Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0HCEGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:06:55 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43239 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab0HCEGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:06:53 -0400
Date: Tue, 3 Aug 2010 09:36:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 5/5] memcg: use spinlock in page_cgroup instead of
 bit_spinlock
Message-ID: <20100803040645.GH3863@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
 <20100802192006.a395889a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100802192006.a395889a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-08-02 19:20:06]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch replaces bit_spinlock with spinlock. In general,
> spinlock has good functinality than bit_spin_lock and we should use
> it if we have a room for it. In 64bit arch, we have extra 4bytes.
> Let's use it.
> expected effects:
>  - use better codes.
>  - ticket lock on x86-64
>  - para-vitualization aware lock
> etc..
> 
> Chagelog: 20090729
>  - fixed page_cgroup_is_locked().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> --

The additional space usage is a big concern, I think saving space
would be of highest priority. I understand the expected benefits, but
a spinlock_t per page_cgroup is quite expensive at the moment. If
anything I think it should be a config option under CONFIG_DEBUG or
something else to play with and see the side effects.

-- 
	Three Cheers,
	Balbir
