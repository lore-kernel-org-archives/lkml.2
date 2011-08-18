Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1HRNZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:25:44 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50762 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1HRNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:25:43 -0400
Date: Thu, 18 Aug 2011 15:25:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
Message-ID: <20110818132531.GA10441@somewhere>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <4E4BEE1F.9060500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4BEE1F.9060500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 09:36:47AM -0700, Avi Kivity wrote:
> On 08/15/2011 08:51 AM, Frederic Weisbecker wrote:
> >= What's the interface =
> >
> >We use the cpuset interface by adding a nohz flag to it.
> >As long as a CPU is part of a nohz cpuset, then this CPU will
> >try to enter into adaptive nohz mode when it can, even if it is part
> >of another cpuset that is not nohz.
> >
> >
> 
> Why not do it unconditionally?  That is, if all the conditions are
> fulfilled, disable the tick regardless of any cpuset settings.

Because I'm not sure it's a win on every workload. This involves
some hooks here and there (syscall slow path), IPIs, etc...

But perhaps if one day it is proven to behave better in most cases
then we can make it enabled by default on cpusets?
