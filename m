Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1LBMqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:46:13 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:49388 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab1LBMqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:46:11 -0500
Date: Fri, 2 Dec 2011 13:45:58 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-ID: <20111202124558.GB1295@cmpxchg.org>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
 <1322751913.4699.19.camel@twins>
 <20111202092217.50d72f71.kamezawa.hiroyu@jp.fujitsu.com>
 <1322817850.4699.69.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322817850.4699.69.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 10:24:10AM +0100, Peter Zijlstra wrote:
> On Fri, 2011-12-02 at 09:22 +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > Yes, that's an idea. But we also have another stupid shadow swap accounting
> > table.  This can be disabled at boot, too. 
> 
> Bah I thought it was just the page frame thing, hnaz any plans to kill
> this swap array as well?

I haven't looked at the swap accounting at all yet, sorry.  But where
did this discussion go all of a sudden? :-)

That array is not allocated at all when the memory controller is
disabled at boot-time.

Rather, we have those mem_cgroup_disabled() conditionals everytime we
enter the memory controller from the VM and the idea is to patch them
out during boot, since you can not re-enable the thing anyway.
