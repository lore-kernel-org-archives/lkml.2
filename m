Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab1EEU5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:57:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42520 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1EEU5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:57:00 -0400
Date: Thu, 5 May 2011 22:56:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
Message-ID: <20110505205656.GH2925@one.firstfloor.org>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org> <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm> <20110505175713.GG2925@one.firstfloor.org> <1304626621.20980.19.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304626621.20980.19.camel@work-vm>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 01:17:01PM -0700, john stultz wrote:
> On Thu, 2011-05-05 at 19:57 +0200, Andi Kleen wrote:
> > > I suspect the reason this hasn't been triggered on x86 or power6 is due
> > > to compiler or processor optimizations reordering the assignment to in
> > > effect make it atomic. Or maybe the timing window to see the issue is
> > > harder to observe?
> > 
> > On x86 all aligned stores are atomic. So I don't see how this 
> > could be a problem ever.
> 
> No no. The issue was with the fact that in update_xtime_cache we modify
> xtime_cache twice (once setting it possibly backwards to xtime, then
> adding in the nsec offset).

Ok makes sense. So the obvious fix is to compute the values first
in temporaries, then write them with appropiate wmb()s? 

For the reader it should not make any difference.

-Andi
