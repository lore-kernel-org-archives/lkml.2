Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762510Ab2ERBrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:47:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:30946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2ERBrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:47:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167885125"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
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
Subject: RE: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq
 can not be migrated out of it and remove CPU0 check in smp_callin()
Thread-Topic: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any irq
 can not be migrated out of it and remove CPU0 check in smp_callin()
Thread-Index: AQHNLsnr6BtSjocSukKcCXDRs7eVypbE9IsAgABuzwCABEt1gIAFZvGA//+54cA=
Date: Fri, 18 May 2012 01:47:09 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220077185AE@ORSMSX105.amr.corp.intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
	 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1205111352330.3231@ionos>
	 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
	 <20120514121725.GA10840@gmail.com>
 <1337294829.1997.96.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1337294829.1997.96.camel@sbsiddha-desk.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4I1lIJd023052

> -----Original Message-----
> From: Siddha, Suresh B
> Sent: Thursday, May 17, 2012 3:47 PM
> To: Ingo Molnar
> Cc: Luck, Tony; Thomas Gleixner; Yu, Fenghua; Ingo Molnar; H Peter
> Anvin; Linus Torvalds; Andrew Morton; Mallick, Asit K; Arjan Dan De Ven;
> Brown, Len; Srivatssa S. Bhat; Randy Dunlap; Chen Gong; linux-kernel;
> linux-pm; x86; Peter Zijlstra
> Subject: Re: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any
> irq can not be migrated out of it and remove CPU0 check in smp_callin()
> 
> On Mon, 2012-05-14 at 14:17 +0200, Ingo Molnar wrote:
> > * Tony Luck <tony.luck@intel.com> wrote:
> >
> > > Biggest code impact of that is the extra code to bring cpu0
> > > back online using NMI instead of INIT. We can't use INIT
> > > because if cpu0 gets one, it just resets the whole machine :-(
> > > But obviously we'd like to avoid special cases where there is
> > > a sane way to do so.
> >
> > Could we just standardize on NMI bringup during regular bootup?
> 
> May be we can use the NMI or even better monitor/mwait based bringup to
> re-online an AP that is currently offline in play_dead(), specifically
> if we haven't lost that AP processor state because of suspend/resume
> event etc.
> 
> This can speed-up online if we want to use light weight online/offline
> of the AP's for saving power on mobile platforms.

Then booting up AP via INIT and putting AP online back via NMI/mwait will have different wakeup method and code. We probably need a way to tell if it is first AP bringup or online AP/BSP during run time.

And if offlined CPU is not in mwait (e.g. CPU without mwait feature), mwait based bringup won't work. Do we need to fall back to NMI wakeup if offlined CPU is not in mwait?

Thanks.

-Fenghua
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
