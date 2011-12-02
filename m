Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1LBMwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:52:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:58662 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088Ab1LBMwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:52:36 -0500
Subject: Re: [PATCH] jump_label: jump_label for boot options.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
In-Reply-To: <20111202124558.GB1295@cmpxchg.org>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322751913.4699.19.camel@twins>
	 <20111202092217.50d72f71.kamezawa.hiroyu@jp.fujitsu.com>
	 <1322817850.4699.69.camel@twins>  <20111202124558.GB1295@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 13:53:27 +0100
Message-ID: <1322830407.2822.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 13:45 +0100, Johannes Weiner wrote:
> On Fri, Dec 02, 2011 at 10:24:10AM +0100, Peter Zijlstra wrote:
> > On Fri, 2011-12-02 at 09:22 +0900, KAMEZAWA Hiroyuki wrote:
> > > 
> > > Yes, that's an idea. But we also have another stupid shadow swap accounting
> > > table.  This can be disabled at boot, too. 
> > 
> > Bah I thought it was just the page frame thing, hnaz any plans to kill
> > this swap array as well?
> 
> I haven't looked at the swap accounting at all yet, sorry.  But where
> did this discussion go all of a sudden? :-)
> 
> That array is not allocated at all when the memory controller is
> disabled at boot-time.
> 
> Rather, we have those mem_cgroup_disabled() conditionals everytime we
> enter the memory controller from the VM and the idea is to patch them
> out during boot, since you can not re-enable the thing anyway.

Yeah, but without those arrays you could.. this boot time switch really
is a wart and if you don't have the shadow page frame and shadow swap
accounting muck stuff you could runtime flip all this..

I've no objection to using jump_labels fwiw, we're looking to do the
same with the cpu controller for the nr_cgroups == 0 case. But boot time
stuff just doesn't make sense to me.

