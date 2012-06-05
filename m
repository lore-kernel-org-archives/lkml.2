Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2FEQTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:19:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:8764 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab2FEQTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:19:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108114659"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Topic: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
Thread-Index: AQHNQoAPrrSeWa27GkKpGKrFiBcRb5brDNOAgAAGFYCAAEURgIAAdQ+AgAAVOjCAAHk9gP//iyfg
Date: Tue, 5 Jun 2012 16:18:35 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122007728081@ORSMSX105.amr.corp.intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
	 <alpine.LFD.2.02.1206042203590.3086@ionos>
	 <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
	 <1338881971.28282.150.camel@twins>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007727023@ORSMSX105.amr.corp.intel.com>
 <1338912565.2749.9.camel@twins>
In-Reply-To: <1338912565.2749.9.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, June 05, 2012 9:09 AM
> To: Yu, Fenghua
> Cc: Rusty Russell; Thomas Gleixner; Ingo Molnar; H Peter Anvin; Siddha,
> Suresh B; Luck, Tony; Mallick, Asit K; Arjan Dan De Ven; linux-kernel;
> x86; linux-pm; Srivatsa S. Bhat
> Subject: RE: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait
> or nmi
> 
> On Tue, 2012-06-05 at 16:02 +0000, Yu, Fenghua wrote:
> >
> > Users can consolidate processes on a few online CPU's and offline the
> > rest when workload is light.
> 
> No they can't, hotplug is a root only op.

That's right. A root admin does this. Actually some Linux people are adjusting online/offline CPU's based on workload to save power in their business. There are some advantages for online/offline CPU's than idling CPU's.

> 
> > This consolidation can save more power and have better performance
> > than idling CPU's because hot cache in online CPU's and offline CPU's
> > can be allocated in same package.
> 
> Yeah, or you fix the load-balancer to do this.

