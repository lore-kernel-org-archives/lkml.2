Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2K3Qxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:53:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648Ab2K3Qxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:53:50 -0500
Date: Fri, 30 Nov 2012 17:53:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121130165347.GO29317@dhcp22.suse.cz>
References: <20121126132149.GD17860@dhcp22.suse.cz>
 <20121130032918.59B3F780@pobox.sk>
 <20121130124506.GH29317@dhcp22.suse.cz>
 <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
 <20121130161923.GN29317@dhcp22.suse.cz>
 <20121130172651.B6917602@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130172651.B6917602@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 30-11-12 17:26:51, azurIt wrote:
> >Could you also post your complete containers configuration, maybe there
> >is something strange in there (basically grep . -r YOUR_CGROUP_MNT
> >except for tasks files which are of no use right now).
> 
> 
> Here it is:
> http://www.watchdog.sk/lkml/cgroups.gz

The only strange thing I noticed is that some groups have 0 limit. Is
this intentional?
grep memory.limit_in_bytes cgroups | grep -v uid | sed 's@.*/@@' | sort | uniq -c
      3 memory.limit_in_bytes:0
    254 memory.limit_in_bytes:104857600
    107 memory.limit_in_bytes:157286400
     68 memory.limit_in_bytes:209715200
     10 memory.limit_in_bytes:262144000
     28 memory.limit_in_bytes:314572800
      1 memory.limit_in_bytes:346030080
      1 memory.limit_in_bytes:524288000
      2 memory.limit_in_bytes:9223372036854775807
-- 
Michal Hocko
SUSE Labs
