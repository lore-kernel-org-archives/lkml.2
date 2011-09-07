Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1IGTWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:22:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41460 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1IGTWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:22:42 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Wed, 07 Sep 2011 21:22:22 +0200
In-Reply-To: <20110907152009.GA3868@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com>
	 <20110607154542.GA2991@linux.vnet.ibm.com>
	 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
	 <20110608163234.GA23031@linux.vnet.ibm.com>
	 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
	 <20110610181719.GA30330@linux.vnet.ibm.com>
	 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
	 <20110615053716.GA390@linux.vnet.ibm.com>
	 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315423342.11101.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 20:50 +0530, Srivatsa Vaddagiri wrote:
> 
> Fix excessive idle time reported when cgroups are capped. 

Where from? The whole idea of bandwidth caps is to introduce idle time,
so what's excessive and where does it come from?

>  The patch introduces the notion of "steal" 

The virt folks already claimed steal-time and have it mean something
entirely different. You get to pick a new name.

> (or "grace") time which is the surplus
> time/bandwidth each cgroup is allowed to consume, subject to a maximum
> steal time (sched_cfs_max_steal_time_us). Cgroups are allowed this "steal"
> or "grace" time when the lone task running on a cpu is about to be throttled.

Ok, so this is a solution to an unstated problem. Why is it a good
solution?

Also, another tunable, yay!
