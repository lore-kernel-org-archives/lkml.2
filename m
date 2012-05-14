Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab2ENMRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:17:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2ENMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:17:32 -0400
Date: Mon, 14 May 2012 14:17:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq
 can not be migrated out of it and remove CPU0 check in smp_callin()
Message-ID: <20120514121725.GA10840@gmail.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1205111352330.3231@ionos>
 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> Biggest code impact of that is the extra code to bring cpu0 
> back online using NMI instead of INIT. We can't use INIT 
> because if cpu0 gets one, it just resets the whole machine :-( 
> But obviously we'd like to avoid special cases where there is 
> a sane way to do so.

Could we just standardize on NMI bringup during regular bootup?

Thanks,

	Ingo
