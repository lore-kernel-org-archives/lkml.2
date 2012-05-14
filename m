Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab2ENQkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:40:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:1800 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab2ENQkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="99908187"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
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
Thread-Index: AQHNLsnrDnWT9m5F3ESFhoZxeANiH5bE9IsAgARE+bGAAEfbIA==
Date: Mon, 14 May 2012 16:40:37 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192EED9F@ORSMSX104.amr.corp.intel.com>
References: <1336666614-21090-1-git-send-email-fenghua.yu@intel.com>
 <1336666614-21090-5-git-send-email-fenghua.yu@intel.com>
 <alpine.LFD.2.02.1205111352330.3231@ionos>
 <CA+8MBbJbEWTR2Tawa2SzcJ-mZSPzZ12a9usR5eQu=PhArZwXLA@mail.gmail.com>
 <20120514121725.GA10840@gmail.com>
In-Reply-To: <20120514121725.GA10840@gmail.com>
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

> Could we just standardize on NMI bringup during regular bootup?

I don't know for sure (Fenghua?) but I'd guess not. CPU#0 is being brought *back* online
by this NMI ... i.e. it has been online before, so interrupt vector tables and CR3
etc. have been set to Linux-y values. When bringing other cpus online for the first
time they have nothing set so we'd still have to use INIT.

-Tony
