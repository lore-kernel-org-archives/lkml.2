Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1A0Xr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:47:58 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60120 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1A0Xr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:47:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 08:41:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gleb Natapov <gleb@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [patch 2/3] memcg: prevent endless loop on huge page charge
Message-Id: <20110128084155.4189b4ff.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127141451.GA14512@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
	<20110127103438.GC2401@cmpxchg.org>
	<20110127134645.GA14309@cmpxchg.org>
	<20110127140024.GR14750@redhat.com>
	<20110127141451.GA14512@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 15:14:51 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Hi Gleb,
> 
> On Thu, Jan 27, 2011 at 04:00:24PM +0200, Gleb Natapov wrote:
> > On Thu, Jan 27, 2011 at 02:46:45PM +0100, Johannes Weiner wrote:
> > > The charging code can encounter a charge size that is bigger than a
> > > regular page in two situations: one is a batched charge to fill the
> > > per-cpu stocks, the other is a huge page charge.
> > > 
> > > This code is distributed over two functions, however, and only the
> > > outer one is aware of huge pages.  In case the charging fails, the
> > > inner function will tell the outer function to retry if the charge
> > > size is bigger than regular pages--assuming batched charging is the
> > > only case.  And the outer function will retry forever charging a huge
> > > page.
> > > 
> > > This patch makes sure the inner function can distinguish between batch
> > > charging and a single huge page charge.  It will only signal another
> > > attempt if batch charging failed, and go into regular reclaim when it
> > > is called on behalf of a huge page.
> > > 
> > Yeah, that is exactly the case I am debugging right now. Came up with
> > different solution: pass page_size to __mem_cgroup_do_charge() and
> > compare csize with page_size (not CHARGE_SIZE). Not sure which solution
> > it more correct.
> 
> I guess it makes no difference, but using CHARGE_SIZE gets away
> without adding another parameter to __mem_cgroup_do_charge().
> 

My new one is similar to this ;)

Thanks,
-Kame



