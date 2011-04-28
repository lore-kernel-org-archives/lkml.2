Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1D1CJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:09:28 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:45197 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab1D1CJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:09:27 -0400
Date: Thu, 28 Apr 2011 11:04:00 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ying Han <yinghan@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCHv4] memcg: reclaim memory from node in round-robin
Message-Id: <20110428110400.2808f50d.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110427165120.a60c6609.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinx+4zXaO3rhHRUzr3m-K-2_NMTQw@mail.gmail.com>
	<20110428093513.5a6970c0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110428103705.a284df87.nishimura@mxp.nes.nec.co.jp>
	<20110428104912.6f86b2ee.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 10:49:12 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 28 Apr 2011 10:37:05 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > +	if (time_after(mem->next_scan_node_update, jiffies))
> > > +		return;
> > > +
> > Shouldn't it be time_before() or time_after(jiffies, next_scan_node_update) ?
> > 
> > Looks good to me, otherwise.
> > 
> 
> time_after(a, b) returns true when a is after b.....you're right.
> ==
> Now, memory cgroup's direct reclaim frees memory from the current node.
> But this has some troubles. In usual, when a set of threads works in
> cooperative way, they are tend to on the same node. So, if they hit
> limits under memcg, it will reclaim memory from themselves, it may be
> active working set.
> 
> For example, assume 2 node system which has Node 0 and Node 1
> and a memcg which has 1G limit. After some work, file cacne remains and
> and usages are
>    Node 0:  1M
>    Node 1:  998M.
> 
> and run an application on Node 0, it will eats its foot before freeing
> unnecessary file caches.
> 
> This patch adds round-robin for NUMA and adds equal pressure to each
> node. When using cpuset's spread memory feature, this will work very well.
> 
> But yes, better algorithm is appreciated.
> 
> From: Ying Han <yinghan@google.com>
> Signed-off-by: Ying Han <yinghan@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
