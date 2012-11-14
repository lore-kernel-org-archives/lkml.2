Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422930Ab2KNNpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:45:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422757Ab2KNNpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:45:32 -0500
Date: Wed, 14 Nov 2012 14:45:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 3/4] mm, oom: remove redundant sleep in pagefault oom
 handler
Message-ID: <20121114134530.GC4929@dhcp22.suse.cz>
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1211140113200.32125@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211140113200.32125@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 01:15:25, David Rientjes wrote:
> out_of_memory() will already cause current to schedule if it has not been
> killed, so doing it again in pagefault_out_of_memory() is redundant.
> Remove it.
> 
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/oom_kill.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -683,5 +683,4 @@ void pagefault_out_of_memory(void)
>  		out_of_memory(NULL, 0, 0, NULL, false);
>  		clear_zonelist_oom(zonelist, GFP_KERNEL);
>  	}
> -	schedule_timeout_killable(1);
>  }

-- 
Michal Hocko
SUSE Labs
