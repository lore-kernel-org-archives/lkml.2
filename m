Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab2FUIxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:53:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40839 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab2FUIxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:53:36 -0400
Message-ID: <1340268801.21745.162.camel@twins>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Thu, 21 Jun 2012 10:53:21 +0200
In-Reply-To: <1340267442.21745.156.camel@twins>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	 <1340231192.21745.154.camel@twins>
	 <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
	 <1340267442.21745.156.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 10:30 +0200, Peter Zijlstra wrote:
> On Thu, 2012-06-21 at 02:46 +0200, Frederic Weisbecker wrote:
> > > So I understand why s390,ia64 want the sched hook, but I don't see why
> > > ppc would need it, their account_process_tick() can fold whatever they
> > > need on the tick.
> > 
> > I think in any case you need to flush the time on a descheduling task otherwise
> > its pending time will be accounted later to the next task when it
> > receives an irq.
> > 
> > So I fear we still need that sched switch hook even with per cpu data. This
> > may be a simple account_system_vtime() call. 
> 
> Did I miss a per-task something in there?

Gah yeah.. I was staring too hard at the arch code and missed the task
accounting in the core code.

OK, so that switch hook stays :-)
