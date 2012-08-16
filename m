Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2HPOAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:00:54 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39428 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab2HPOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:00:52 -0400
Date: Thu, 16 Aug 2012 16:00:44 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
Message-ID: <20120816160044.1941f6f4@de.ibm.com>
In-Reply-To: <20120816125556.GG19716@somewhere>
References: <1344953810-20564-1-git-send-email-fweisbec@gmail.com>
	<1344953810-20564-2-git-send-email-fweisbec@gmail.com>
	<20120815170347.323507b1@de.ibm.com>
	<20120815190901.GD19716@somewhere>
	<20120816095336.4eeb3ce1@de.ibm.com>
	<1345109897.11751.31.camel@pasglop>
	<20120816125556.GG19716@somewhere>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12081614-3548-0000-0000-000002D7AFFC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012 14:55:59 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Aug 16, 2012 at 07:38:17PM +1000, Benjamin Herrenschmidt wrote:
> > On Thu, 2012-08-16 at 09:53 +0200, Martin Schwidefsky wrote:
> > > Hmm, ok. But then the description should be reworded not to be specific to
> > > the power architecture (the part of the message about "This also enables
> > > accounting of stolen time on logically-partitioned systems running on IBM
> > > POWER5-based machines."). 
> > 
> > Which is not very helpful to somebody running on a POWER6 or 7 (which
> > also support that option just fine :-)
> > 
> > So yes, the description should definitely be improved.
> 
> All right. How about something like the below?
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 894b073..5f5f8c2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -276,9 +276,9 @@ config VIRT_CPU_ACCOUNTING
>  	  accounting.  This is done by reading a CPU counter on each
>  	  kernel entry and exit and on transitions within the kernel
>  	  between system, softirq and hardirq state, so there is a
> -	  small performance impact.  This also enables accounting of
> -	  stolen time on logically-partitioned systems running on
> -	  IBM POWER5-based machines.
> +	  small performance impact.  In the case of IBM POWER > 5, this
> +	  also enables accounting of stolen time on logically-partitioned
> +	  systems.
> 
>  config BSD_PROCESS_ACCT
>  	bool "BSD Process Accounting"
> 

VIRT_CPU_ACCOUNTING will enable steal time for s390 as well.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

