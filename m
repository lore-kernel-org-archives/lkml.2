Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab2ERDe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:34:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39936 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2ERDe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 23:34:57 -0400
Message-ID: <4FB5C347.6010105@zytor.com>
Date: Thu, 17 May 2012 20:34:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq
 can not be migrated out of it and remove CPU0 check in smp_callin()
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>  <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>  <alpine.LFD.2.02.1205111352330.3231@ionos>  <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>  <20120514121725.GA10840@gmail.com> <1337294829.1997.96.camel@sbsiddha-desk.sc.intel.com> <3E5A0FA7E9CA944F9D5414FEC6C71220077185AE@ORSMSX105.amr.corp.intel.com>
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220077185AE@ORSMSX105.amr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 06:47 PM, Yu, Fenghua wrote:
> 
> Then booting up AP via INIT and putting AP online back via NMI/mwait
> will have different wakeup method and code. We probably need a way to
> tell if it is first AP bringup or online AP/BSP during run time.
> 
> And if offlined CPU is not in mwait (e.g. CPU without mwait feature),
> mwait based bringup won't work. Do we need to fall back to NMI wakeup
> if offlined CPU is not in mwait?
> 

I guess we need NMI (or just re-SIPI) in that case, since we're spinning
in CLI; HLT...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

