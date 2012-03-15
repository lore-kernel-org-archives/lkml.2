Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab2COO1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:27:07 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46176 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab2COO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:27:03 -0400
Date: Thu, 15 Mar 2012 23:26:58 +0900
From: Simon Horman <horms@verge.net.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: notify sysfs when voltage is set
Message-ID: <20120315142657.GD3129@verge.net.au>
References: <1331813073-714-1-git-send-email-horms@verge.net.au>
 <20120315124631.GJ3138@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315124631.GJ3138@opensource.wolfsonmicro.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:46:31PM +0000, Mark Brown wrote:
> On Thu, Mar 15, 2012 at 09:04:33PM +0900, Simon Horman wrote:
> 
> > This allows libudev to be used to monitor voltage changes and thus allows
> > user-space code to avoid polling the sysfs entry for changes.
> 
> I notice that we don't generate similar events for cpufreq...  what are
> the performance implications from firing off udev (which isn't free)
> every time we scale the CPU frequency?  It feels like this might be
> disruptive, especially with a governor like ondemand which responds to
> system load.

Hi Mark,

that is a good point and to be honest not one that I had considered.  For
the use-case that I have in mind, which is basically to log voltage changes
over time, it may be acceptable to rate-limit notifications somehow. But at
that point I may be better off just polling.

Out of interest, how often can ondemand potentially change the voltage?
