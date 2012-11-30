Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab2K3QT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:19:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab2K3QTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:19:25 -0500
Date: Fri, 30 Nov 2012 17:19:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121130161923.GN29317@dhcp22.suse.cz>
References: <20121126013855.AF118F5E@pobox.sk>
 <20121126131837.GC17860@dhcp22.suse.cz>
 <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130165937.F9564EBE@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 16:59:37, azurIt wrote:
> >> Here is the full boot log:
> >> www.watchdog.sk/lkml/kern.log
> >
> >The log is not complete. Could you paste the comple dmesg output? Or
> >even better, do you have logs from the previous run?
> 
> 
> What is missing there? All kernel messages are logging into
> /var/log/kern.log (it's the same as dmesg), dmesg itself was already
> rewrited by other messages. I think it's all what that kernel printed.

Early boot messages are missing - so exactly the BIOS memory map I was
asking for. As the NUMA has been excluded it is probably not that
relevant anymore.
The important question is why you see VM_FAULT_OOM and whether memcg
charging failure can trigger that. I don not see how this could happen
right now because __GFP_NORETRY is not used for user pages (except for
THP which disable memcg OOM already), file backed page faults (aka
__do_fault) use mem_cgroup_newpage_charge which doesn't disable OOM.
This is a real head scratcher.

Could you also post your complete containers configuration, maybe there
is something strange in there (basically grep . -r YOUR_CGROUP_MNT
except for tasks files which are of no use right now).
-- 
Michal Hocko
SUSE Labs
