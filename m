Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab1ALAyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:54:16 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37184 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab1ALAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:54:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 12 Jan 2011 09:48:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 2/2] memcg: remove charge variable in unmap_and_move
Message-Id: <20110112094820.e8f5e443.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <f6f15f90ecf0df32586fcc103038fd7ea01acc16.1294735182.git.minchan.kim@gmail.com>
References: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
	<f6f15f90ecf0df32586fcc103038fd7ea01acc16.1294735182.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 17:51:12 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> memcg charge/uncharge could be handled by mem_cgroup_[prepare/end]
> migration itself so charge local variable in unmap_and_move lost the role
> since we introduced 01b1ae63c2.
> 
> In addition, the variable name is not good like below.
> 
> int unmap_and_move()
> {
> 	charge = mem_cgroup_prepare_migration(xxx);
> 	..
> 		BUG_ON(charge); <-- BUG if it is charged?
> 		..
> uncharge:
> 		if (!charge)    <-- why do we have to uncharge !charge?
> 			mem_group_end_migration(xxx);
> 	..
> }
> 
> So let's remove unnecessary and confusing variable.
> 
> Suggested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

