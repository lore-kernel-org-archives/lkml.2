Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1A0Xon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:44:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60017 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1A0Xom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:44:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 08:38:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/7] memcg : fix charge function of THP allocation.
Message-Id: <20110128083839.c9a73b73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127103438.GC2401@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127103438.GC2401@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 11:34:38 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Jan 21, 2011 at 03:44:30PM +0900, KAMEZAWA Hiroyuki wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When THP is used, Hugepage size charge can happen. It's not handled
> > correctly in mem_cgroup_do_charge(). For example, THP can fallback
> > to small page allocation when HUGEPAGE allocation seems difficult
> > or busy, but memory cgroup doesn't understand it and continue to
> > try HUGEPAGE charging. And the worst thing is memory cgroup
> > believes 'memory reclaim succeeded' if limit - usage > PAGE_SIZE.
> > 
> > By this, khugepaged etc...can goes into inifinite reclaim loop
> > if tasks in memcg are busy.
> > 
> > After this patch 
> >  - Hugepage allocation will fail if 1st trial of page reclaim fails.
> >  - distinguish THP allocaton from Bached allocation. 
> 
> This does too many things at once.  Can you split this into more
> patches where each one has a single objective?  Thanks.
> 

Sure, will do.

I'm now testing new ones.

Thanks,
-Kame

