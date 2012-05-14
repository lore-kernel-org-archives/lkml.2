Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2ENUD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:03:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:30206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619Ab2ENUD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:03:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99990934"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
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
Thread-Index: AQHNLsnr6BtSjocSukKcCXDRs7eVypbE9IsAgABuzwCABEt1gIAASYqA//+/wuA=
Date: Mon, 14 May 2012 20:03:54 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220077175FE@ORSMSX105.amr.corp.intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1205111352330.3231@ionos>
 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
 <20120514121725.GA10840@gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F192EED9F@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EED9F@ORSMSX104.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Luck, Tony
> Sent: Monday, May 14, 2012 9:41 AM
> To: Ingo Molnar
> Cc: Thomas Gleixner; Yu, Fenghua; Ingo Molnar; H Peter Anvin; Linus
> Torvalds; Andrew Morton; Mallick, Asit K; Arjan Dan De Ven; Siddha,
> Suresh B; Brown, Len; Srivatssa S. Bhat; Randy Dunlap; Chen Gong;
> linux-kernel; linux-pm; x86; Peter Zijlstra
> Subject: RE: [PATCH v6 04/12] x86/smpboot.c: Don't offline CPU0 if any
> irq can not be migrated out of it and remove CPU0 check in smp_callin()
> 
> > Could we just standardize on NMI bringup during regular bootup?
> 
> I don't know for sure (Fenghua?) but I'd guess not. CPU#0 is being
> brought *back* online
> by this NMI ... i.e. it has been online before, so interrupt vector
> tables and CR3
> etc. have been set to Linux-y values. When bringing other cpus online
> for the first
> time they have nothing set so we'd still have to use INIT.

Yes, on platforms of apic_physflat, apic_flat, x2apicapic, etc, the INIT sequence is necessary for bringing up AP's because AP's are in BIOS initialized unknown status without interrupt tables and CR3 etc.

Thanks.

-Fenghua
