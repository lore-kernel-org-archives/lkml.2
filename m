Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1DHEzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:55:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:6507 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1DHEzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,322,1299484800"; 
   d="scan'208";a="415849501"
Subject: Re: [PATCH]sched: convert wall-time to vruntime for
 check_preempt_tick
From: Shaohua Li <shaohua.li@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
In-Reply-To: <1302230959.7551.14.camel@marge.simson.net>
References: <20110407124332.GA31809@sli10-conroe.sh.intel.com>
	 <1302183260.8065.9.camel@marge.simson.net>
	 <1302222953.3981.88.camel@sli10-conroe>
	 <1302230959.7551.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 12:55:22 +0800
Message-ID: <1302238522.3981.94.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 10:49 +0800, Mike Galbraith wrote:
> On Fri, 2011-04-08 at 08:35 +0800, Shaohua Li wrote:
> > On Thu, 2011-04-07 at 21:34 +0800, Mike Galbraith wrote:
> > > On Thu, 2011-04-07 at 20:43 +0800, Shaohua Li wrote:
> > > > In check_preempt_tick(), delta is vruntime and ideal_runtime is wall runtime.
> > > > Comparing vruntime and ideal_runtime looks buggy.
> > > 
> > > Why is that buggy?  It's a distance in units ns, ala wakeup_granularity,
> > > a number.  This number just happens to be variable.
> > vruntime is scaled wall-time. In all other places we do the scale from
> > my understanding. I'm wondering why not do it here.
> 
> The purpose was to ensure that there is not too much spread, just like
> wakeup preemption.  Using the number that determines tick induced spread
> as the spread caliper seems perfectly fine to me.
But we scale wakeup_granularity too for wakeup preemption, see
wakeup_gran(), am I missing anything?

