Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab0KKNEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:04:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:42736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0KKNEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:04:02 -0500
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101111124015.GA9706@localhost>
References: <20101111100628.GA24728@localhost>
	 <1289478978.2084.74.camel@laptop>  <20101111124015.GA9706@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 14:04:16 +0100
Message-ID: <1289480656.2084.80.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:40 +0800, Wu Fengguang wrote:
> On Thu, Nov 11, 2010 at 08:36:18PM +0800, Peter Zijlstra wrote:
> > On Thu, 2010-11-11 at 18:06 +0800, Wu Fengguang wrote:
> > > 
> > > I run into this kernel panic since 2.6.27-rc1.  2.6.36 boots OK.
> > > It's not yet fixed in 2.6.37-rc1-next-20101110. I can conveniently
> > > test any debug patches.
> > > 
> > Happen to have a .config handy? I've never seen this..
> 
> Here it is. 

When I boot that .config and use the sched_debug boot param I get lots
of interesting stuff:

[    1.187507] CPU0 attaching sched-domain:
[    1.191431]  domain 0: span 0-5 level MC
[    1.195373]   groups: 0 1 2 3 4 5
[    1.198812] ERROR: parent span is not a superset of domain->span
[    1.204813]   domain 1: span 0-4,6 level CPU
[    1.209100] ERROR: domain->groups does not contain CPU0
[    1.214324]    groups: 5 (cpu_power = 6144) 7 (cpu_power = 2048)
[    1.220417] ERROR: groups don't span domain->span
[    1.225118]    domain 2: span 0-7 level NODE
[    1.229403]     groups:
[    1.231868] ERROR: domain->cpu_power not set


Looks like something is totally screwy there and we start the
load-balancer before we actually build the sched domain tree or
something silly like that.

Will try and figure out how the heck that's happening, Ingo any clue?
