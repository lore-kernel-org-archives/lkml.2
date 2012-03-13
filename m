Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2CMGqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:46:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:45459 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2CMGqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:46:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118124383"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNADar8jfAhS12dUCWb8Li45vgkJZnyN7g
Date: Tue, 13 Mar 2012 06:46:15 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
 <1331546307.18960.26.camel@twins>
In-Reply-To: <1331546307.18960.26.camel@twins>
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
> Sent: Monday, March 12, 2012 5:58 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Mon, 2012-03-12 at 09:27 +0000, Liu, Chuansheng wrote:
> > The solution is just to send smp call to active cpus instead of online
> > cpus.
> 
> BTW, that solution is broken because !active cpus can still be online and
> actually running stuff, so sending IPIs to them is perfectly fine and actually
> required.
> 
Based on current code base, the IPI can be handled only after the cpu is active, before CPU is active,
Any sending IPI is meanless.
