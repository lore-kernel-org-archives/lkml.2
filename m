Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031144Ab2CVV3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:29:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031055Ab2CVV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:29:43 -0400
Date: Thu, 22 Mar 2012 14:29:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: change behavior of moving charges at task move
Message-Id: <20120322142941.01e601c0.akpm@linux-foundation.org>
In-Reply-To: <4F69A4C4.4080602@jp.fujitsu.com>
References: <4F69A4C4.4080602@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 18:52:04 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> As discussed before, I post this to fix the spec and implementation of task moving.
> Then, do you think what target kernel version should be ? 3.4/3.5 ?
> but yes, it may be late for 3.4....

Well, the key information here is "what effect does the bug have upon
users".

> In documentation, it's said that 'shared anon are not moved'.
> But in implementation, the check was wrong.
> 
>   if (!move_anon() || page_mapcount(page) > 2)
> 
> Ah, memcg has been moving shared anon pages for a long time.
> 
> Then, here is a discussion about handling of shared anon pages.
> 
>  - It's complex
>  - Now, shared file caches are moved in force.
>  - It adds unclear check as page_mapcount(). To do correct check,
>    we should check swap users, etc.
>  - No one notice this implementation behavior. So, no one get benefit
>    from the design.
>  - In general, once task is moved to a cgroup for running, it will not
>    be moved....
>  - Finally, we have control knob as memory.move_charge_at_immigrate.
> 
> Here is a patch to allow moving shared pages, completely. This makes
> memcg simpler and fix current broken code.
> 
> Note:
>  IIUC, libcgroup's cgroup daemon moves tasks after exec().
>  So, it's not affected.
>  libcgroup's command "cgexec" does move itsef to a memcg and call exec()
>  without fork(). it's not affected.
> 
> Changelog:
>  - fixed PageAnon() check.
>  - remove call of lookup_swap_cache()
>  - fixed Documentation.

But you forgot to tell us :(

