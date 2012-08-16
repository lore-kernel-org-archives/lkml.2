Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2HPOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:01:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:59170 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149Ab2HPOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:01:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="181798977"
Message-ID: <502CFD35.5000801@linux.intel.com>
Date: Thu, 16 Aug 2012 07:01:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: preeti <preeti@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <502C98E8.20800@linux.vnet.ibm.com>
In-Reply-To: <502C98E8.20800@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *Power policy*:
> 
> So how is power policy different? As Peter says,'pack more than spread
> more'.

this is ... a dubiously general statement.

for good power, at least on Intel cpus, you want to spread. Parallelism is efficient.

the only thing you do not want to do, is wake cpus up for
tasks that only run extremely briefly (think "100 usec" or less).

so maybe the balance interval is slightly different, or more, you don't balance tasks that
historically ran only for brief periods


