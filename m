Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762376Ab2EQWx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:53:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38241 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211Ab2EQWx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:53:26 -0400
Message-ID: <4FB58143.8060007@zytor.com>
Date: Thu, 17 May 2012 15:52:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
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
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com> <1336666614-21090-5-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1205111352330.3231@ionos> <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com> <20120514121725.GA10840@gmail.com>
In-Reply-To: <20120514121725.GA10840@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 05:17 AM, Ingo Molnar wrote:
> 
> * Tony Luck <tony.luck@intel.com> wrote:
> 
>> Biggest code impact of that is the extra code to bring cpu0 
>> back online using NMI instead of INIT. We can't use INIT 
>> because if cpu0 gets one, it just resets the whole machine :-( 
>> But obviously we'd like to avoid special cases where there is 
>> a sane way to do so.
> 
> Could we just standardize on NMI bringup during regular bootup?
> 

The first instance has to be SIPI because you can't give the CPU an NMI
without the IDT being setup.  We *could* assume that the processor is
parked in real mode with the valid real-mode IDT set up (in which case
the vector at physical address 8 applies) but that seems to assume a lot
from the BIOS for little gain.  In particular I suspect that UEFI-based
BIOSes may very well park the CPU in protected or long mode.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

