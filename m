Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0GaAsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 20:48:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:49371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0GaAsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 20:48:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,290,1278313200"; 
   d="scan'208";a="823427432"
Subject: Re: [patch 1/2] workqueue: mark init_workqueues() as
 early_initcall()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100730165522.22dc982b.akpm@linux-foundation.org>
References: <20100730215751.690706748@sbsiddha-MOBL3.sc.intel.com>
	 <20100730165522.22dc982b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 30 Jul 2010 17:48:10 -0700
Message-Id: <1280537290.2682.19.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 16:55 -0700, Andrew Morton wrote:
> On Fri, 30 Jul 2010 14:57:37 -0700
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Mark init_workqueues() as early_initcall() and thus it will be initialized
> > before smp bringup. init_workqueues() registers for the hotcpu notifier
> > and thus it should cope with the processors that are brought online after
> > the workqueues are initialized.
> > 
> > x86 smp bringup code uses workqueues and uses a workaround for the
> > cold boot process (as the workqueues are initialized post smp_init()).
> > Marking init_workqueues() as early_initcall() will pave the way for
> > cleaning up this code.
> > 
> 
> I sure hope this has been tested against linux-next. 
> kernel/workqueue.c has been vastly changed and -tip doesn't know about
> that.  linux-next should include -tip and is hence a better tree to
> develop and test against.
> 
> AFAICT the main thing which needs checking is that the new
> init_workqueues() doesn't do anything which requires that
> sched_init_smp() has been executed.
> 
> The patch otherwise looks OK and killing that hack in the x86 code was
> most merciful.
> 
> for_each_gcwq_cpu(), for_each_online_gcwq_cpu() and for_each_cwq_cpu()
> make me cry.

hmm.. too many changes in linux-next.

Yes, as far as these patches are concerned, they work against linux-next
aswell. Just posted -v2 which is on top of linux-next. ia64 also had the
same issue, addressed in -v2 aswell.

thanks,
suresh



