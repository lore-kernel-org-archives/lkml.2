Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1JCBjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 21:39:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1JCBi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 21:38:59 -0400
Date: Sun, 2 Oct 2011 18:38:55 -0700
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Fleming <matt@console-pimps.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111003013855.GG31799@mtj.dyndns.org>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <20110930165206.GA22048@redhat.com>
 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
 <20110930235625.GD2658@mtj.dyndns.org>
 <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317474209.12973.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317474209.12973.15.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Andrew and Linus)

On Sat, Oct 01, 2011 at 03:03:29PM +0200, Peter Zijlstra wrote:
> On Sat, 2011-10-01 at 11:16 +0100, Matt Fleming wrote:
> > I also think Thomas/Peter mentioned something about latency in
> > delivering timer signals because of contention on the per-process
> > siglock. They might have some more details on that. 
> 
> Right, so signal delivery is O(nr_threads), which precludes being able
> to deliver signals from hardirq context, leading to lots of ugly in -rt.

Signal delivery is O(#threads)?  Delivery of fatal signal is of course
but where do we walk all threads during non-fatal signal deliveries?
What am I missing?

> Breaking up the multitude of uses of siglock certainly seems worthwhile
> esp. if it also allows for a cleanup of the horrid mess called
> signal_struct (which really should be called process_struct or so).
> 
> And yes, aside from that the siglock can be quite contended because its
> pretty much the one lock serializing all of the process wide state.

Hmmm... can you please be a bit more specific?  I personally has never
seen a case where siglock becomes a problem and IIUC Matt also doesn't
have actual use case at hand.  Given the fragile nature of this part
of kernel, it would be nice to know what the return is.

Thank you.

-- 
tejun
