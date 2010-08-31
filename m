Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0HaCQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:16:39 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60283 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0HaCQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:16:37 -0400
Date: Tue, 31 Aug 2010 11:14:48 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "menage@google.com" <menage@google.com>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 3/5] memcg: use ID instead of pointer in page_cgroup
Message-Id: <20100831111448.259e2d8c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100825170900.3feababc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100825170435.15f8eb73.kamezawa.hiroyu@jp.fujitsu.com>
	<20100825170900.3feababc.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 17:09:00 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, addresses of memory cgroup can be calculated by their ID without complex.
> This patch relplaces pc->mem_cgroup from a pointer to a unsigned short.
> On 64bit architecture, this offers us more 6bytes room per page_cgroup.
> Use 2bytes for blkio-cgroup's page tracking. More 4bytes will be used for
> some light-weight concurrent access.
> 
> We may able to move this id onto flags field but ...go step by step.
> 
> Changelog: 20100824
>  - fixed comments, and typo.
> Changelog: 20100811
>  - using new rcu APIs, as rcu_dereference_check() etc.
> Changelog: 20100804
>  - added comments to page_cgroup.h
> Changelog: 20100730
>  - fixed some garbage added by debug code in early stage
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
