Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1A1Flb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:41:31 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62876 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1A1Fla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:41:30 -0500
Date: Fri, 28 Jan 2011 14:37:28 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH 2/4] memcg: fix charge path for THP and allow
 early retirement
Message-Id: <20110128143728.e3ee2dbc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110128122608.cf9be26b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122608.cf9be26b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 12:26:08 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> When THP is used, Hugepage size charge can happen. It's not handled
> correctly in mem_cgroup_do_charge(). For example, THP can fallback
> to small page allocation when HUGEPAGE allocation seems difficult
> or busy, but memory cgroup doesn't understand it and continue to
> try HUGEPAGE charging. And the worst thing is memory cgroup
> believes 'memory reclaim succeeded' if limit - usage > PAGE_SIZE.
> 
> By this, khugepaged etc...can goes into inifinite reclaim loop
> if tasks in memcg are busy.
> 
> After this patch 
>  - Hugepage allocation will fail if 1st trial of page reclaim fails.
> 
> Changelog:
>  - make changes small. removed renaming codes.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
