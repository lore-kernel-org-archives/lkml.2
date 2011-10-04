Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1JDHhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:37:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52306 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab1JDHhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:37:53 -0400
Date: Tue, 4 Oct 2011 00:37:49 -0700
From: Tejun Heo <htejun@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Fleming <matt@console-pimps.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111004073749.GD15637@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <20110930165206.GA22048@redhat.com>
 <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
 <20110930235625.GD2658@mtj.dyndns.org>
 <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317474209.12973.15.camel@twins>
 <20111003013855.GG31799@mtj.dyndns.org>
 <alpine.LFD.2.02.1110031544340.1489@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1110031544340.1489@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 03, 2011 at 03:56:26PM +0200, Thomas Gleixner wrote:
> > Signal delivery is O(#threads)?  Delivery of fatal signal is of course
> > but where do we walk all threads during non-fatal signal deliveries?
> > What am I missing?
> 
> Delivery of any process wide signal can result in an O(thread) walk to
> find a valid target. That's true for user space originated and kernel
> space originated (e.g. posix timers) signals.

Ooh, right.  Wakeup currently does linear scan of threads, but this is
mostly a separate issue.  As Peter suggested, tracking wakeup target
probably is one sane way to solve this.

Do you think siglock would still be a problem even after O(N) problem
is solved?  Maybe that would lessen contention enough such that the
locking scope wouldn't matter anymore?  Unless breaking up of the
locks results in nice separate hot domains, being finer-grained
doesn't mean much after all.

Thank you.

-- 
tejun
