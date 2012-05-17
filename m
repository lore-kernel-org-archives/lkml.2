Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030600Ab2EQWtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:49:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:15570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030492Ab2EQWtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:49:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141875023"
Subject: Re: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq
 can not be migrated out of it and remove CPU0 check in smp_callin()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 17 May 2012 15:47:09 -0700
In-Reply-To: <20120514121725.GA10840@gmail.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
	 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1205111352330.3231@ionos>
	 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
	 <20120514121725.GA10840@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337294829.1997.96.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 14:17 +0200, Ingo Molnar wrote:
> * Tony Luck <tony.luck@intel.com> wrote:
> 
> > Biggest code impact of that is the extra code to bring cpu0 
> > back online using NMI instead of INIT. We can't use INIT 
> > because if cpu0 gets one, it just resets the whole machine :-( 
> > But obviously we'd like to avoid special cases where there is 
> > a sane way to do so.
> 
> Could we just standardize on NMI bringup during regular bootup?

May be we can use the NMI or even better monitor/mwait based bringup to
re-online an AP that is currently offline in play_dead(), specifically
if we haven't lost that AP processor state because of suspend/resume
event etc.

This can speed-up online if we want to use light weight online/offline
of the AP's for saving power on mobile platforms.

thanks,
suresh

