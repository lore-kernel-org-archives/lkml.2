Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2DTRd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:33:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:50512 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2DTRdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:33:25 -0400
Subject: Re: load balancing regression since commit 367456c7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1334942012.3796.50.camel@schen9-DESK>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>  <1334940042.3796.48.camel@schen9-DESK>
	 <1334940837.2463.70.camel@laptop>  <1334942012.3796.50.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 19:33:22 +0200
Message-ID: <1334943202.2463.71.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 10:13 -0700, Tim Chen wrote:
> On Fri, 2012-04-20 at 18:53 +0200, Peter Zijlstra wrote:
> > On Fri, 2012-04-20 at 09:40 -0700, Tim Chen wrote:
> > > We also do not see regression for hackbench on WSM-EP, but only 
> > > on machines with Sandy-Bridge EP (2 socket, 8 cores/socket, HT enabled).  
> > 
> > Argh, Suresh, any idea what could be different and relevant to this
> > issue between WSM and SNB -EP ?
> > 
> > Tim, can you see the problem on the desktop SNB part? That's the only
> > SNB I have available.
> > 
> > > We are not running hackbench in cgroup for this test.
> > > 
> > > The Sandy Bridge EP machines installed has FC16, so I think it uses 
> > > systemd. The machine on our WSM EP has FC15, which also has systemd.
> > 
> > Ah, but your .config has:
> > 
> > CONFIG_CGROUP_SCHED=y
> > CONFIG_SCHED_AUTOGROUP=y
> > 
> > and systemd, when cpu-cgroup is available, will automagically use it.
> > 
> > Could you disable those two CONFIG knobs and see if it persists?
> > 
> 
> Turning those off did recover the regression.

OK, I'll go stare at the cgroup part then.. Thanks!

