Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab0KOOvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:51:04 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:58153 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab0KOOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:51:01 -0500
Date: Mon, 15 Nov 2010 15:50:57 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
Message-ID: <20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1289677083.2109.167.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	<20101111170815.024542355@linux.vnet.ibm.com>
	<1289677083.2109.167.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010 20:38:02 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > 
> > Currently steal time is only accounted for the whole system. With this
> > patch we add steal time to the per task CPU time accounting.
> > The triplet "user time", "system time" and "steal time" represents
> > all consumed CPU time on hypervisor based systems. 
> 
> Does that really make sense? Its not like the hypervisor really knows
> anything about tasks and won't steal from one? Its really a vcpu
> feature.
> 
> What added benefit will all this extra accounting give?

Currently the linux kernel keeps track of used cpu cycles per task,
steal time is reported only per cpu. With the patch steal cycles are
reported per task just like used cpu cycles, giving the complete picture
on a per task basis. Without the patch you don't know if the task has
been waiting or got its cycles stolen. A matter of granularity.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

