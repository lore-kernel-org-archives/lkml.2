Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2JPFOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:14:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:58948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab2JPFOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="234353663"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "Brown, Len" <len.brown@intel.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Thread-Topic: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Thread-Index: AQHNq1e0cdLRWLkn60qkdlE2ARg+FJe7WVDQgAB8b4D//4uFoA==
Date: Tue, 16 Oct 2012 05:14:46 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD91@ORSMSX105.amr.corp.intel.com>
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
	<3E5A0FA7E9CA944F9D5414FEC6C7122030B0DD68@ORSMSX105.amr.corp.intel.com>
 <20121016.140313.279437418.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20121016.140313.279437418.d.hatayama@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> My motivation is to use multiple CPUs in order to quickly generate
> >> crash dump on the machine with huge amount of memory. I assume such
> >> machine tends to also have a lot of CPUs. So disabling one CPU would
> >> be no problem.
> >
> > Luckily you don't need to disable any CPU to archive your goal with
> > the BSP hotplug pachest:)
> >
> > On a dual core/single thread machine, this means you get 100%
> performance
> > boost with BSP's help.
> >
> > Plus crash dump kernel code is better structured by not treating BSP
> > specially.
> >
> 
> Hello Fenghua.
> 
> I've of course noticed your patch set and locally tested, but I saw
> NMI to BSP failed in the 2nd kernel. I'll send a log to you later.
> 
> BTW, I tested with your previous v8 patch set. Did you change
> something during v8 to v9 relevant to this issue?

In the patch 0/12 in v9, I describe what change is in v9 on the top of v8:

v9: Add Intel vendor check to support the feature on Intel platforms only.

Did you see the BSP wake up failure on the latest tip tree?

There is a rcu regression issue which prevents BSP from waking up in 3.6.0.
The issue has been fixed on 10/12. The commit is a4fbe35a. Please make sure
your tip tree has this commit.

Thanks.

-Fenghua


Thanks.

-Fenghua
