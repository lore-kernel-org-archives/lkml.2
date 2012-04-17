Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2DQQoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:44:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:52301 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab2DQQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:44:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="130752802"
Subject: Re: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1334664553.28150.87.camel@twins>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 09:44:14 -0700
Message-ID: <1334681054.3796.28.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 14:09 +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-10 at 18:06 -0700, Tim Chen wrote:
> >                   |--56.52%-- load_balance
> >                   |          idle_balance
> >                   |          __schedule
> >                   |          schedule 
> 
> Ahh, I know why I didn't see it, I have a CONFIG_PREEMPT kernel and
> idle_balancing stops once its gotten a single task over instead of
> achieving proper balance.
> 
> And since hackbench generates insanely long runqueues and the patch that
> caused your regression 'fixed' the lock-breaking it will now iterate the
> entire runqueue if needed to achieve balance, which hurts.
> 
> I think the patch I send ought to work, let me try disabling
> CONFIG_PREEMPT.
> --

yes, CONFIG_PREEMPT is turned off on my side.  With the patch that you
sent, the slowed down went from a factor of 4 down to a factor 2. 

So the run time is now twice as long vs four time as long vs v3.3
kernel.

Tim

