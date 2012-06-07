Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2FGUbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:31:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:39539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab2FGUbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:31:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153101549"
Subject: Re: [patch] irq: use config_enabled(SMP) checks to cleanup
 irq_set_affinity() for UP
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com,
        Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 07 Jun 2012 13:31:23 -0700
In-Reply-To: <CAE9FiQXh82++LRJnFbYXAVQmCPM00M8HO0KQ523WYD+rZKvt2w@mail.gmail.com>
References: <20120509093001.GD8585@gmail.com>
	 <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	 <1336589196-14498-2-git-send-email-suresh.b.siddha@intel.com>
	 <1336593505.4634.11.camel@sbsiddha-desk.sc.intel.com>
	 <20120510075031.GC28395@gmail.com>
	 <1339025388.28766.70.camel@sbsiddha-desk.sc.intel.com>
	 <CAE9FiQXh82++LRJnFbYXAVQmCPM00M8HO0KQ523WYD+rZKvt2w@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339101083.28766.80.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 18:36 -0700, Yinghai Lu wrote:
> On Wed, Jun 6, 2012 at 4:29 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > On Ingo's request, re-basing the previous version
> > (http://marc.info/?l=linux-kernel&m=133667389223282) to the latest -tip
> > tree. Thanks.
> > ---
> > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > Subject: irq: use config_enabled(CONFIG_SMP) checks to cleanup irq_set_affinity() for UP
> >
> > Use config_enabled(CONFIG_SMP) checks for cleaning up the ifdef CONFIG_SMP
> > around irq_set_affinity routines in io_apic and irq_remapping subsystems.
> 
> can you just use
> if (nr_cpu_ids > 1)
> checking instead
> if config_enabled(CONFIG_SMP)

Idea is to not have any extra runtime checks if CONFIG_SMP is enabled
and which is when all the smp affinity routines are used/invoked.

thanks,
suresh


