Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1AYIdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:33:08 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:46222 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1AYIdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:33:07 -0500
Date: Tue, 25 Jan 2011 17:31:23 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 3/3] memcg: fix race at move_parent around
 compound_order()
Message-Id: <20110125173123.08359210.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110125150516.fb2f5e06.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
	<20110125150516.fb2f5e06.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 15:05:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Based on 
> 2.6.38-rc2 + 
>  mm-memcontrolc-fix-uninitialized-variable-use-in-mem_cgroup_move_parent.patch
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> A fix up mem_cgroup_move_parent() which use compound_order() in
> asynchrnous manner. This compound_order() may return unknown value
> because we don't take lock. Use PageTransHuge() and HPAGE_SIZE instead of
> it.
> 
> Also clean up for mem_cgroup_move_parent(). 
>  - remove unnecessary initialization of local variable.
>  - rename charge_size -> page_size
>  - remove unnecessary (wrong) comment.
>  - added a comment about THP.
> 
> Changelog:
>  - fixed page size calculation for avoiding race.
> 
> Note:
>  Current design take compound_page_lock() in caller of move_account().
>  This should be revisited when we implement direct move_task of hugepage
>  without splitting.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
