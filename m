Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab1BDBCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:02:33 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:50060 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1BDBCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:02:32 -0500
Date: Fri, 4 Feb 2011 09:53:54 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [patch 3/5] memcg: fold __mem_cgroup_move_account into caller
Message-Id: <20110204095354.7332d8d4.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110204090738.4eb6d766.kamezawa.hiroyu@jp.fujitsu.com>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-4-git-send-email-hannes@cmpxchg.org>
	<20110204090738.4eb6d766.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Feb 2011 09:07:38 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu,  3 Feb 2011 15:26:04 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > It is one logical function, no need to have it split up.
> > 
> > Also, get rid of some checks from the inner function that ensured the
> > sanity of the outer function.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I think there was a reason to split them...but it seems I forget it..
> 
IIRC, it's me who split them up in commit 57f9fd7d.

But the purpose of the commit was cleanup move_parent() and move_account()
to use move_accout() in move_charge() later.
So, there was no technical reason why I split move_account() and __move_account().
It was just because I liked to make each functions do one thing: check validness
and actually move account.

Anyway, I don't have any objection to folding them. page_is_cgroup_locked()
can be removed by this change.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Daisuke Nishimura.
