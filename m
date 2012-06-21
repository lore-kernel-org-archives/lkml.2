Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2FUIbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:31:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab2FUIa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:30:59 -0400
Message-ID: <1340267442.21745.156.camel@twins>
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
Date: Thu, 21 Jun 2012 10:30:42 +0200
In-Reply-To: <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	 <1340231192.21745.154.camel@twins>
	 <CAFTL4hz9UZr0Xfd4m3WTBma8vSvbm0Lg8o=oXsjFbpPfG9RxjQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 02:46 +0200, Frederic Weisbecker wrote:
> > So I understand why s390,ia64 want the sched hook, but I don't see why
> > ppc would need it, their account_process_tick() can fold whatever they
> > need on the tick.
> 
> I think in any case you need to flush the time on a descheduling task otherwise
> its pending time will be accounted later to the next task when it
> receives an irq.
> 
> So I fear we still need that sched switch hook even with per cpu data. This
> may be a simple account_system_vtime() call. 

Did I miss a per-task something in there?
