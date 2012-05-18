Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272Ab2ERGqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:46:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40481 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab2ERGqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:46:08 -0400
Date: Fri, 18 May 2012 08:46:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20120518064601.GC429@gmail.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1205111352330.3231@ionos>
 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
 <20120514121725.GA10840@gmail.com>
 <4FB58143.8060007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB58143.8060007@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/14/2012 05:17 AM, Ingo Molnar wrote:
> > 
> > * Tony Luck <tony.luck@intel.com> wrote:
> > 
> >> Biggest code impact of that is the extra code to bring cpu0 
> >> back online using NMI instead of INIT. We can't use INIT 
> >> because if cpu0 gets one, it just resets the whole machine :-( 
> >> But obviously we'd like to avoid special cases where there is 
> >> a sane way to do so.
> > 
> > Could we just standardize on NMI bringup during regular bootup?
> > 
> 
> The first instance has to be SIPI because you can't give the 
> CPU an NMI without the IDT being setup.  We *could* assume 
> that the processor is parked in real mode with the valid 
> real-mode IDT set up (in which case the vector at physical 
> address 8 applies) but that seems to assume a lot from the 
> BIOS for little gain.  In particular I suspect that UEFI-based 
> BIOSes may very well park the CPU in protected or long mode.

Ok, fair enough.

Thanks,

	Ingo
