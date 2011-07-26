Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab1GZRoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:44:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1GZRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:44:06 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=Qv89JQfnOpAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=5Dbxrd4wnBevCbeDC3oA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] cgroup/kmemcheck: No need to annotate base anymore
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1311702110.3526.98.camel@gandalf.stny.rr.com>
References: <1311699911.3526.87.camel@gandalf.stny.rr.com>
	 <20110726173816.GA26597@tiehlicka.suse.cz>
	 <1311702110.3526.98.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Jul 2011 13:44:04 -0400
Message-ID: <1311702244.3526.100.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 13:41 -0400, Steven Rostedt wrote:

> > We can still fall back to vmalloc allocation (even though it is really
> > not probable that alloc_pages_exact_nid would fail that early).
> > Is vmalloc a problem here? (sorry I am not familiar with kmemleak
> > internals) The original code didn't distinguish kmalloc vs. vmalloc.
> > 
> 
> Good question. I forgot to add the maintainer of kmemleak to the Cc
> list. (fixed here).

Depending on the answer, I suspect that the result will be to keep the
not_leak call, and just add a call directly to kmemleak_alloc() in the
page_alloc() side.

I'll have a patch ready on hand when we find out :)

-- Steve


