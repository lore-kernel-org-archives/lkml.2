Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627Ab2COALg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:11:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:14388 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759355Ab2COALf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:11:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77663195"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNAcbuNZzs3JjW0Uu/4BUvgje4I5Zqe/Ag
Date: Thu, 15 Mar 2012 00:11:32 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
 <1331718197.18960.106.camel@twins>
In-Reply-To: <1331718197.18960.106.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Wednesday, March 14, 2012 5:43 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Wed, 2012-03-14 at 06:27 +0000, Liu, Chuansheng wrote:
> > On the unplug case, after set the CPU to !active, we do not need IPI
> > handling for the corresponding CPU before it is set to offline. I did
> > not find any impact that limiting the smp_call_function just after CPU
> > is active.
> 
> Have a look at Alpha, it's flush_tlb_mm() can use smp_call_function(), in
> the !active,online case you very much still need to tlb flush that cpu.
> 
> The fact that it works on a limited use case on x86 doesn't say anything much
> at all.
Thanks your pointing out, do you have any other perfect solution for this issue?
As for the stress test result, advancing the setting active before setting online broken
something either.
