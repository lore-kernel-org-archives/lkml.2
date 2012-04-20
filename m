Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2DTRNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:13:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:24513 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab2DTRNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="132155019"
Subject: Re: load balancing regression since commit 367456c7
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Shi <alex.shi@intel.com>,
        Ying <ying.huang@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1334940837.2463.70.camel@laptop>
References: <1334106376.19157.89.camel@schen9-DESK>
	 <1334664553.28150.87.camel@twins>  <1334681054.3796.28.camel@schen9-DESK>
	 <1334930421.2463.60.camel@laptop>  <1334940042.3796.48.camel@schen9-DESK>
	 <1334940837.2463.70.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 10:13:32 -0700
Message-ID: <1334942012.3796.50.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 18:53 +0200, Peter Zijlstra wrote:
> On Fri, 2012-04-20 at 09:40 -0700, Tim Chen wrote:
> > We also do not see regression for hackbench on WSM-EP, but only 
> > on machines with Sandy-Bridge EP (2 socket, 8 cores/socket, HT enabled).  
> 
> Argh, Suresh, any idea what could be different and relevant to this
> issue between WSM and SNB -EP ?
> 
> Tim, can you see the problem on the desktop SNB part? That's the only
> SNB I have available.
> 
> > We are not running hackbench in cgroup for this test.
> > 
> > The Sandy Bridge EP machines installed has FC16, so I think it uses 
> > systemd. The machine on our WSM EP has FC15, which also has systemd.
> 
> Ah, but your .config has:
> 
> CONFIG_CGROUP_SCHED=y
> CONFIG_SCHED_AUTOGROUP=y
> 
> and systemd, when cpu-cgroup is available, will automagically use it.
> 
> Could you disable those two CONFIG knobs and see if it persists?
> 

Turning those off did recover the regression.

Tim

