Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1H2RMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:12:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64962 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1H2RMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:12:01 -0400
Date: Mon, 29 Aug 2011 19:11:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to idle
 enter/exit APIs
Message-ID: <20110829171155.GD9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
 <1314627922.2816.65.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314627922.2816.65.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:25:22PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > To prepare for nohz / idle logic split, pull out the rcu dynticks
> > idle mode switching to strict idle entry/exit areas.
> > 
> > So we make the dyntick mode possible without always involving rcu
> > extended quiescent state. 
> 
> Why is this a good thing? I would be thinking that if we're a userspace
> bound task and we disable the tick rcu would be finished on this cpu and
> thus the extended quiescent state is just what we want?

But we can stop the tick from the kernel, not just userspace.
