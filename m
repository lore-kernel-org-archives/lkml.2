Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1DFN2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:28:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:16003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1DFN2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,310,1299484800"; 
   d="scan'208";a="675934322"
From: "Shi, Alex" <alex.shi@intel.com>
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>
Date: Wed, 6 Apr 2011 21:28:38 +0800
Subject: RE: [PATCH] sched: recover sched_yield task running time increase
Thread-Topic: [PATCH] sched: recover sched_yield task running time increase
Thread-Index: Acv0KH4MfLkMS3gxStypBREQwFmg2QANdYkg
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B4BBA01D83D@shsmsx502.ccr.corp.intel.com>
References: <1302042823-23022-1-git-send-email-alex.shi@intel.com>
	 <4D9BF512.6080309@redhat.com>  <1302070509.15889.7351.camel@debian>
 <1302073289.21156.17.camel@marge.simson.net>
In-Reply-To: <1302073289.21156.17.camel@marge.simson.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > NACK
>> >
>> > This was switched off by default and under
>> > the sysctl sched_compat_yield for a reason.
>> >
>> > Reintroducing it under that sysctl option
>> > may be acceptable, but by default it would
>> > be doing the wrong thing for other workloads.
>>
>> I can implement this as sysctl option. But when I checked again the man
>> page of sched_yield. I have some concerns on this.
>>
>> ----
>>        int sched_yield(void);
>>
>> DESCRIPTION
>>        A  process  can  relinquish  the processor voluntarily without blocking by calling sched_yield().
>>        The process will then be moved to the end of the queue for its static priority and a new  process
>>        gets to run.
>> ----
>>
>> If a application calls sched_yield system call, most of time it is not
>> want to be launched again right now. so the man page said "the caller
>> process will then be moved to the _end_ of the queue..."
>
>Moving a yielding nice 0 task behind a SCHED_IDLE (or nice 19) task
>could be incredibly painful.

Good reminder! Do you have more detailed idea on this? 
