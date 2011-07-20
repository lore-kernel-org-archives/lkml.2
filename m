Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1GTGDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 02:03:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38878 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1GTGDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 02:03:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Jul 2011 14:55:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: change memcg_oom_mutex to spinlock
Message-Id: <20110720145553.7703dbcb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <b24894c23d0bb06f849822cb30726b532ea3a4c5.1310732789.git.mhocko@suse.cz>
References: <cover.1310732789.git.mhocko@suse.cz>
	<b24894c23d0bb06f849822cb30726b532ea3a4c5.1310732789.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011 17:29:51 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> memcg_oom_mutex is used to protect memcg OOM path and eventfd interface
> for oom_control. None of the critical sections which it protects sleep
> (eventfd_signal works from atomic context and the rest are simple linked
> list resp. oom_lock atomic operations).
> Mutex is also too heavy weight for those code paths because it triggers
> a lot of scheduling. It also makes makes convoying effects more visible
> when we have a big number of oom killing because we take the lock
> mutliple times during mem_cgroup_handle_oom so we have multiple places
> where many processes can sleep.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


