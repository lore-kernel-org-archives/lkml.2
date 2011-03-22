Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1CVWYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:24:46 -0400
Received: from linux-sh.org ([111.68.239.195]:45997 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1CVWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:24:44 -0400
Date: Wed, 23 Mar 2011 07:23:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kay Sievers <kay.sievers@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Message-ID: <20110322222347.GA3978@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103222130.46603.rjw@sisk.pl> <1300826390.1815.5.camel@zag> <201103222200.52131.rjw@sisk.pl> <1300828356.1815.15.camel@zag> <20110322214922.GA7503@linux-sh.org> <1300831256.1815.22.camel@zag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300831256.1815.22.camel@zag>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:00:56PM +0100, Kay Sievers wrote:
> On Wed, 2011-03-23 at 06:49 +0900, Paul Mundt wrote:
> > The comment at the top of sys.c says:
> > 
> >  * sys.c - pseudo-bus for system 'devices' (cpus, PICs, timers, etc)
> 
> Which is what we need to get rid of. It does not make any sense on the
> global picture to have anything like that exported to userspace.
> 
So far I haven't heard any rationale for why it doesn't. Exporting CPU
state to userspace certainly makes sense, and the sysdev model has worked
reasonably for CPUs, memory nodes, etc.

> People should really stop messing around in /sys for optimization
> purposes. We have a common device model, and need to use it. Sysdevs do
> not fit into that model.
> 
> I can't tell how that fits into your use case, but please use something
> else than sysfs, if you need device information exported, but you can't
> use "struct device".
> 
As long as CPU state is present in sysfs people will be tied to it for
per-CPU kobjects and the like, and until something concrete is proposed
for what to do about these cases there's not much chance of sysdevs going
away.

Once cpufreq, timekeeping, and NUMA node state have migrated to whatever
the driver model folks find acceptable, I'll happily follow suit.
