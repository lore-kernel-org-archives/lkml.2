Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1JMFgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 01:36:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32825 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JMFgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 01:36:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 13 Oct 2011 14:35:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Satoru Moriya <satoru.moriya@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        hannes@cmpxchg.org
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Message-Id: <20111013143501.a59efa5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
	<20111010153723.6397924f.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
	<20111011125419.2702b5dc.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
	<20111011135445.f580749b.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com>
	<alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516D0EA@USINDEVS02.corp.hds.com>
	<alpine.DEB.2.00.1110121654120.30123@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011 17:01:21 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 12 Oct 2011, Satoru Moriya wrote:

> > I understand what you concern. But in some area such as banking,
> > stock exchange, train/power/plant control sysemts etc this kind
> > of tunable is welcomed because they can tune their systems at
> > their own risk.
> > 
> 
> You haven't tried the patch that increases the priority of kswapd when 
> such a latency sensitive thread triggers background reclaim?

I don't read full story but....how about adding a new syscall like

==
sys_mem_shrink(int nid, int nr_scan_pages, int flags)

This system call scans LRU of specified nodes and free pages on LRU.
This scan nr_scan_pages in LRU and returns the number of successfully
freed pages.
==

Then, running this progam in SCHED_IDLE, a user can make free pages while
the system is idle. If running in the highest priority, a user can keep
free pages as he want. If a user run this under a memcg, user can free
pages in a memcg. 

Maybe many guys don't want to export memory-shrink facility to userland ;)
This is just an idea.

Thanks,
-Kame

