Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1LABND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 20:13:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:2429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1LABNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 20:13:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,274,1320652800"; 
   d="scan'208";a="97236795"
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>,
        "Shi, Alex" <alex.shi@intel.com>, PaulTurner <pjt@google.com>
Date: Wed, 30 Nov 2011 17:17:04 -0800
In-Reply-To: <1322559859.2921.190.camel@twins>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
	 <1322135263.2921.12.camel@twins>
	 <1322524316.21329.64.camel@sbsiddha-desk.sc.intel.com>
	 <1322559859.2921.190.camel@twins>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322702224.21329.88.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 01:44 -0800, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 15:51 -0800, Suresh Siddha wrote:
> > Current mainline code kicks the idle load balancer if there are two busy
> > cpus in the system. Above mentioned modification makes this decision
> > some what better. For example, two busy cpu's in two different sockets
> > or two busy cpu's in a dual-core single socket system will never kick
> > idle load balancer (as there is no need).
> 
> Except in power balance mode (although that's probably busted anyway),

It is already busted, no doubt about that.

> where we want to aggregate the two tasks over two sockets onto one
> socket.

So was there any discussion regarding restoring the power savings mode
at the recent scheduler bof? Even in the latest platforms, there is a
small power savings when we consolidate the two tasks in two sockets
onto one socket (though the power difference is shrinking). Turbo
headroom also plays some role in this. Two tasks in two sockets
potentially have more turbo headroom compared to the two tasks in one
socket and thus increased performance with increased power.

thanks,
suresh

