Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2HPBR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:17:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:56524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab2HPBR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,775,1336374000"; 
   d="scan'208";a="181588531"
Message-ID: <502C4A3F.5040405@linux.intel.com>
Date: Wed, 15 Aug 2012 18:17:51 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>  <502BA7DC.7060907@linux.intel.com> <1345041548.31459.90.camel@twins> <502BB5A3.5000403@linux.intel.com> <502C4973.6050901@redhat.com>
In-Reply-To: <502C4973.6050901@redhat.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 6:14 PM, Rik van Riel wrote:
> On 08/15/2012 10:43 AM, Arjan van de Ven wrote:
> 
>> The easy cop-out is provide the sysadmin a slider.
>> The slightly less easy one is to (and we're taking this approach
>> in the new P state code we're working on) say "in the default
>> setting, we're going to sacrifice up to 5% performance from peak
>> to give you the best power savings within that performance loss budget"
>> (with a slider that can give you 0%, 2 1/2%  5% and 10%)
> 
> On a related note, I am looking at the c-state menu governor.
> 
> We seem to have issues there, with Linux often going into a much
> deeper C state than warranted, which can lead to a fairly steep
> performance penalty for some workloads.
> 

predicting the future is hard.
if you pick a too deep C state, you get a certain fixed performance hit
if you pick a too shallow C state, you get a pretty large power hit (depending on how long you actually stay idle)

also would need to know hw details; at least on Intel a bunch of things are done
by the firmware and some platforms we're not doing the right things as Linux
(or BIOS)

