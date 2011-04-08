Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1DHAf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:35:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:36589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab1DHAfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:35:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,320,1299484800"; 
   d="scan'208";a="676601233"
Subject: Re: [PATCH]sched: convert wall-time to vruntime for
 check_preempt_tick
From: Shaohua Li <shaohua.li@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
In-Reply-To: <1302183260.8065.9.camel@marge.simson.net>
References: <20110407124332.GA31809@sli10-conroe.sh.intel.com>
	 <1302183260.8065.9.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 08:35:53 +0800
Message-ID: <1302222953.3981.88.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 21:34 +0800, Mike Galbraith wrote:
> On Thu, 2011-04-07 at 20:43 +0800, Shaohua Li wrote:
> > In check_preempt_tick(), delta is vruntime and ideal_runtime is wall runtime.
> > Comparing vruntime and ideal_runtime looks buggy.
> 
> Why is that buggy?  It's a distance in units ns, ala wakeup_granularity,
> a number.  This number just happens to be variable.
vruntime is scaled wall-time. In all other places we do the scale from
my understanding. I'm wondering why not do it here.

