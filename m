Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2LQTz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:55:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54643 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2LQTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:55:24 -0500
Date: Mon, 17 Dec 2012 20:55:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121217195510.GA16375@dhcp22.suse.cz>
References: <20121205141722.GA9714@dhcp22.suse.cz>
 <20121206012924.FE077FD7@pobox.sk>
 <20121206095423.GB10931@dhcp22.suse.cz>
 <20121210022038.E6570D37@pobox.sk>
 <20121210094318.GA6777@dhcp22.suse.cz>
 <20121210111817.F697F53E@pobox.sk>
 <20121210155205.GB6777@dhcp22.suse.cz>
 <20121217023430.5A390FD7@pobox.sk>
 <20121217163203.GD25432@dhcp22.suse.cz>
 <20121217192301.829A7020@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217192301.829A7020@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-12-12 19:23:01, azurIt wrote:
> >[Ohh, I am really an idiot. I screwed the first patch]
> >-       bool oom = true;
> >+       bool oom = !(gfp_mask | GFP_MEMCG_NO_OOM);
> >
> >Which obviously doesn't work. It should read !(gfp_mask &GFP_MEMCG_NO_OOM).
> >  No idea how I could have missed that. I am really sorry about that.
> 
> 
> :D no problem :) so, now it should really work as expected and
> completely fix my original problem?

It should mitigate the problem. The real fix shouldn't be that specific
(as per discussion in other thread). The chance this will get upstream
is not big and that means that it will not get to the stable tree
either.

> is it safe to apply it on 3.2.35?

I didn't check what are the differences but I do not think there is
anything to conflict with it.

> Thank you very much!

HTH

-- 
Michal Hocko
SUSE Labs
