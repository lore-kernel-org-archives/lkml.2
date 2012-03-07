Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2CGGGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:06:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:58777 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab2CGGGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:06:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125987553"
Subject: Re: fork_idle from wq cleanup
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1331070074-31717-1-git-send-email-venki@google.com>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
	 <1331070074-31717-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel
Date: Tue, 06 Mar 2012 22:06:21 -0800
Message-ID: <1331100381.2259.2.camel@sbsiddha-mobl2>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 13:41 -0800, Venkatesh Pallipadi wrote:
> I looked at avoiding the wq stuff. But, there is no easy/clean way to do
> if as we have number of routines within copy_process assume current
> being the parent.
> 
> But, we can move most of the complication out of arch code into generic code
> and share it across multiple archs. Here is the patch for that.
> 
> We can easily add x86 percpu idle task on top of this cleanup (except for
> mini-circus to switch idle_task of CPU 0).
> 
> Sorry. The patches for ia64, mips, powerpc and s390 are untested and are in
> "should work" category.
> 
> Overall diffstat looks like
> ---
>  arch/ia64/kernel/smpboot.c |   49 ++---------------------------
>  arch/mips/kernel/smp.c     |   47 +---------------------------
>  arch/powerpc/kernel/smp.c  |   63 ++++----------------------------------
>  arch/s390/kernel/smp.c     |   38 +++--------------------
>  arch/x86/kernel/smpboot.c  |   74 ++++++---------------------------------------
>  include/linux/sched.h      |    1 
>  kernel/fork.c              |   48 +++++++++++++++++++++++++++++
>  7 files changed, 79 insertions(+), 241 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

