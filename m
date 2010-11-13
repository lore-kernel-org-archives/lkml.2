Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0KMUBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:01:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34064 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0KMUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:01:20 -0500
Date: Sun, 14 Nov 2010 01:30:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command
 TASKSTATS_CMD_ATTR_PIDS
Message-ID: <20101113200037.GA9882@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101111170352.732381138@linux.vnet.ibm.com>
 <20101111170813.527389224@linux.vnet.ibm.com>
 <1289677184.2109.171.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1289677184.2109.171.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2010-11-13 20:39:44]:

> On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> > +       if (cmd_pids->cnt > 1000) // XXX socket buffer size check
> 
> What's the implication of this limit? Does that mean that if there's
> more than 1000 tasks on the system the whole interface falls flat on its
> face or does that mean we get at most 1000 tasks worth of information
> per syscall?

Since the transport is not reliable, we need to ensure we don't drop
the data from the kernel and never receive it in user space or
partially receive it in user space.


-- 
	Three Cheers,
	Balbir
