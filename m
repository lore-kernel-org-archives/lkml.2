Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1EFR4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1EFR4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:56:17 -0400
Date: Fri, 6 May 2011 19:55:48 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
Message-ID: <20110506175548.GE6330@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <20110427134613.GI32590@random.random>
 <4DC14474.9040001@gmx.de>
 <20110504143842.GK7838@random.random>
 <4DC31EDE.2020503@gmx.de>
 <20110506011319.GH7838@random.random>
 <4DC3B629.7010409@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC3B629.7010409@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 10:49:45AM +0200, Thomas Sattler wrote:
> > You can already run "grep threshold /proc/zoneinfo" on the system
> > where you reproduced the hang the last time (the one running 2.6.38.4)
> > the one with 1.5G of ram. They all should be well below 512 (so in
> > theory not causing troubles because of the per-cpu stats, and with so
> > few cpus it shouldn't have been such a longstanding problem anyway).
> 
> 'grep threshold /proc/zoneinfo' returns nothing on this machine after
> a reboot and before a crash. Did I tell it's a single core machine?

Hmm single core machine doesn't seem to fit my theory of per-cpu stats
too well... I think it's not impossible but it should only be possible
on smp and maybe it's not reproducible and probably not what you're
dealing with.

The new make-it-worse-patch should help to reproduce though.

If you can "cat /proc/zoneinfo" _during_ the hang (and then run
sysrq+t again to see the status, no need of sysrq+l), it'll help to
try to track this down. I'll recheck your last sysrq+t once again to
see if I get other ideas.

A 'cat /proc/zoneinfo' after the hang resolves itself and the system
is mostly idle, will also be interesting to verify the nr_isolated_*
are all zero.

Thanks,
Andrea
