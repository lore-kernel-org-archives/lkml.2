Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0LCV0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:26:11 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43472 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0LCV0J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:26:09 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>, vatsa@linux.vnet.ibm.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
In-Reply-To: <1291388987.7992.27.camel@marge.simson.net>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291355656.7633.124.camel@marge.simson.net>
	 <20101203134618.GG27994@linux.vnet.ibm.com>
	 <1291387511.7992.15.camel@marge.simson.net>  <4CF90341.4020101@redhat.com>
	 <1291388987.7992.27.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 22:26:18 +0100
Message-ID: <1291411578.2032.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 16:09 +0100, Mike Galbraith wrote:
> On Fri, 2010-12-03 at 09:48 -0500, Rik van Riel wrote:
> > On 12/03/2010 09:45 AM, Mike Galbraith wrote:
> > 
> > > I'll have to go back and re-read that.  Off the top of my head, I see no
> > > way it could matter which container the numbers live in as long as they
> > > keep advancing, and stay in the same runqueue.  (hm, task weights would
> > > have to be the same too or scaled. dangerous business, tinkering with
> > > vruntimes)
> > 
> > They're not necessarily in the same runqueue, the
> > VCPU that is given time might be on another CPU
> > than the one that was spinning on a lock.
> 
> I don't think pumping vruntime cross cfs_rq would be safe, for the
> reason noted (et al).  No competition means vruntime is meaningless.
> Donating just advances a clock that nobody's looking at.

Yeah, cross-cpu you have to model it like exchanging lag. That's a
slightly more complicated trick (esp. since we still don't have a proper
measure for lag) but it should be doable.
