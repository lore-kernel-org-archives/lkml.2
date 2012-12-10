Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2LJJnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:43:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2LJJnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:43:40 -0500
Date: Mon, 10 Dec 2012 10:43:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Message-ID: <20121210094318.GA6777@dhcp22.suse.cz>
References: <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
 <20121130161923.GN29317@dhcp22.suse.cz>
 <20121203151601.GA17093@dhcp22.suse.cz>
 <20121205023644.18C3006B@pobox.sk>
 <20121205141722.GA9714@dhcp22.suse.cz>
 <20121206012924.FE077FD7@pobox.sk>
 <20121206095423.GB10931@dhcp22.suse.cz>
 <20121210022038.E6570D37@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210022038.E6570D37@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 10-12-12 02:20:38, azurIt wrote:
[...]
> Michal,

Hi,
 
> this was printing so many debug messages to console that the whole
> server hangs

Hmm, this is _really_ surprising. The latest patch didn't add any new
logging actually. It just enahanced messages which were already printed
out previously + changed few functions to be not inlined so they show up
in the traces. So the only explanation is that the workload has changed
or the patches got misapplied.

> and i had to hard reset it after several minutes :( Sorry
> but i cannot test such a things in production. There's no problem with
> one soft reset which takes 4 minutes but this hard reset creates about
> 20 minutes outage (mainly cos of disk quotas checking).

Understood.

> Last logged message:
> 
> Dec 10 02:03:29 server01 kernel: [  220.366486] grsec: From 141.105.120.152: bruteforce prevention initiated for the next 30 minutes or until service restarted, stalling each fork 30 seconds.  Please investigate the crash report for /usr/lib/apache2/mpm-itk/apache2[apache2:3586] uid/euid:1258/1258 gid/egid:100/100, parent /usr/lib/apache2/mpm-itk/apache2[apache2:2142] uid/euid:0/0 gid/egid:0/0

This explains why you have seen your machine hung. I am not familiar
with grsec but stalling each fork 30s sounds really bad.

Anyway this will not help me much. Do you happen to still have any of
those logged traces from the last run?

Apart from that. If my current understanding is correct then this is
related to transparent huge pages (and leaking charge to the page fault
handler). Do you see the same problem if you disable THP before you
start your workload? (echo never > /sys/kernel/mm/transparent_hugepage/enabled)
-- 
Michal Hocko
SUSE Labs
