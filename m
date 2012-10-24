Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2JXUsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:48:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab2JXUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:48:37 -0400
Date: Wed, 24 Oct 2012 13:48:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-Id: <20121024134836.a28d223a.akpm@linux-foundation.org>
In-Reply-To: <50884F63.8030606@linux.vnet.ibm.com>
References: <20121012125708.GJ10110@dhcp22.suse.cz>
	<20121023164546.747e90f6.akpm@linux-foundation.org>
	<20121024062938.GA6119@dhcp22.suse.cz>
	<20121024125439.c17a510e.akpm@linux-foundation.org>
	<50884F63.8030606@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 13:28:19 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On 10/24/2012 12:54 PM, Andrew Morton wrote:
> > hmpf.  This patch worries me.  If there are people out there who are
> > regularly using drop_caches because the VM sucks, it seems pretty
> > obnoxious of us to go dumping stuff into their syslog.  What are they
> > supposed to do?  Stop using drop_caches?
> 
> People use drop_caches because they _think_ the VM sucks, or they
> _think_ they're "tuning" their system.  _They_ are supposed to stop
> using drop_caches. :)

Well who knows.  Could be that people's vm *does* suck.  Or they have
some particularly peculiar worklosd or requirement[*].  Or their VM
*used* to suck, and the drop_caches is not really needed any more but
it's there in vendor-provided code and they can't practically prevent
it.

[*] If your workload consists of having to handle large bursts of data
with minimum latency and then waiting around for another burst, it
makes sense to drop all your cached data between bursts.

> What kind of interface _is_ it in the first place?  Is it really a
> production-level thing that we expect users to be poking at?  Or, is it
> a rarely-used debugging and benchmarking knob which is fair game for us
> to tweak like this?

It was a rarely-used mainly-developer-only thing which, apparently, real
people found useful at some point in the past.  Perhaps we should never
have offered it.

> Do we have any valid uses of drop_caches where the printk() would truly
> _be_ disruptive?  Are those cases where we _also_ have real kernel bugs
> or issues that we should be working?  If it disrupts them and they go to
> their vendor or the community directly, it gives us at least a shot at
> fixing the real problems (or fixing the "invalid" use).

Heaven knows - I'm just going from what Michal has told me and various
rumors which keep surfacing on the internet ;)

> Adding taint, making this a single-shot printk, or adding vmstat
> counters are all good ideas.  I guess I think the disruption is a
> feature because I hope it will draw some folks out of the woodwork.

I had a "send mail to akpm@zip.com.au" printk in 3c59x.c many years
ago.  For about two months.  It took *years* before I stopped getting
emails ;)



Gee, I dunno.  I have issues with it :( We could do
printk_ratelimited(one-hour) but I suspect that would defeat Michal's
purpose.

