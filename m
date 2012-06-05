Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2FEP1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:27:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:30435 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2FEP1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175065068"
Message-ID: <4FCE254A.6050504@linux.intel.com>
Date: Tue, 05 Jun 2012 08:27:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
References: <Pine.LNX.4.44L0.1206051014540.1542-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1206051014540.1542-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2012 7:17 AM, Alan Stern wrote:
> On Mon, 4 Jun 2012, Arjan van de Ven wrote:
> 
>>> I disagree.  Deactivating a cpu for power saving is halfway to hotplug
>>> anyway.  I'd rather unify the two cases, where we can specify how dead a
>>> CPU should be, than have individual archs and boards do random hacks.
>>
>> well on PC's there really is no difference at least;
>> idle equals "all power removed" already there.
> 
> This doesn't sound right at all.  Len Brown has often told us that on
> Intel chips, power can't be removed from a package until _all_ the
> cores in the package are idle.

but "cpu hotplug" does not change that.. in fact, cpu hotplug is
implemented as a C state...


and to be specific; power will get removed from the cores one at a time.
you just cannot remove the power from the memory controller until the
last one is off.

