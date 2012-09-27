Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2I0TUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:20:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:40299 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2I0TUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:20:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="198057014"
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Date: Thu, 27 Sep 2012 12:20:57 -0700
In-Reply-To: <50649E1C.40602@linux.vnet.ibm.com>
References: <1348681092.19514.10.camel@cliu38-desktop-build>
	 <1348703122.19514.17.camel@cliu38-desktop-build>
	 <50632767.5050607@linux.vnet.ibm.com>
	 <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com>
	 <50633BA0.5030700@linux.vnet.ibm.com>
	 <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com>
	 <50649E1C.40602@linux.vnet.ibm.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1348773658.6644.36.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 00:12 +0530, Srivatsa S. Bhat wrote:
> On 09/27/2012 04:16 AM, Suresh Siddha wrote:
> > 
> > No. irq_set_affinity()
> > 
> 
> Um? That takes the updated/changed affinity and sets data->affinity to
> that value no? You mentioned that probably the intention of the original
> code was to preserve the user-set affinity mask, but still change the
> underlying interrupt routing. Sorry, but I still didn't quite understand
> what is that part of the code that achieves that.

For the HW routing to be changed we AND it with cpu_online_map and use
that for programming the interrupt entries etc. The user-specified
affinity still has the cpu that is offlined.

And when the cpu comes online and if it is part of the user-specified
affinity, then the HW routing can be again modified to include the new
cpu.

hope this clears it!

thanks.

