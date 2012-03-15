Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032211Ab2COXXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:23:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34724 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2COXXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:23:46 -0400
Date: Fri, 16 Mar 2012 08:23:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: notify sysfs when voltage is set
Message-ID: <20120315232341.GC18690@verge.net.au>
References: <1331813073-714-1-git-send-email-horms@verge.net.au>
 <20120315124631.GJ3138@opensource.wolfsonmicro.com>
 <20120315142657.GD3129@verge.net.au>
 <20120315144708.GM3138@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315144708.GM3138@opensource.wolfsonmicro.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 02:47:08PM +0000, Mark Brown wrote:
> On Thu, Mar 15, 2012 at 11:26:58PM +0900, Simon Horman wrote:
> > On Thu, Mar 15, 2012 at 12:46:31PM +0000, Mark Brown wrote:
> 
> > > I notice that we don't generate similar events for cpufreq...  what are
> > > the performance implications from firing off udev (which isn't free)
> > > every time we scale the CPU frequency?  It feels like this might be
> > > disruptive, especially with a governor like ondemand which responds to
> > > system load.
> 
> > that is a good point and to be honest not one that I had considered.  For
> > the use-case that I have in mind, which is basically to log voltage changes
> > over time, it may be acceptable to rate-limit notifications somehow. But at
> > that point I may be better off just polling.
> 
> Hrm, if you're doing logging then we do already have tracepoints defined
> for voltage changes - could you have your application work with those
> instead of sysfs?  One of the applications of tracepoints is flight
> recorder style system monitoring.

Thanks, that does sound like it would work for me.
I'll look into it further.

> > Out of interest, how often can ondemand potentially change the voltage?
> 
> Depends on how slow it thinks frequency changes are.  I'm not so worried
> about the performance impact from that point of view, I'm more worried
> about what happens when we lower the clock frequency and generate a
> sysfs event causing userspace to wake up and start doing stuff.  It'd be
> bad if ondemand (or another dynamic governor) noticed that the system
> got more busy again and responded by ramping the frequency...

Ok, understood, that could be a bit nasty.


