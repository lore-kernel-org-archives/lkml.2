Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2HVNXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:23:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:34252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HVNXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:23:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="208485835"
Message-ID: <5034DD35.9090504@linux.intel.com>
Date: Wed, 22 Aug 2012 06:23:01 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Mike Galbraith <efault@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <1345043096.31459.106.camel@twins> <502BE38D.9030405@linux.intel.com> <20120820080606.GA6931@gmail.com> <20120820181651.GA737@srcf.ucam.org> <20120821094203.GB12385@gmail.com> <20120821113951.GA22436@srcf.ucam.org> <20120821151910.GA5359@gmail.com> <20120821170254.0b10ece6@pyramind.ukuu.org.uk> <1345614110.4374.65.camel@marge.simpson.net> <5034D878.1000305@linux.intel.com> <20120822132105.GA21852@srcf.ucam.org>
In-Reply-To: <20120822132105.GA21852@srcf.ucam.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/2012 6:21 AM, Matthew Garrett wrote:
> On Wed, Aug 22, 2012 at 06:02:48AM -0700, Arjan van de Ven wrote:
>> On 8/21/2012 10:41 PM, Mike Galbraith wrote:
>>> For my dinky dual core laptop, I suspect you're right, but for a more
>>> powerful laptop, I'd expect spread/don't to be noticeable.
>>
>> yeah if you don't spread, you will waste some power.
>> but.. current linux behavior is to spread.
>> so we can only make it worse.
> 
> Right. For a single socket system the only thing you can do is use two 
> threads in preference to using two cores. That'll keep an extra core in 
> a deep C state for longer, at the cost of keeping the package out of a 
> deep C state for longer. There might be a win if the two processes 
> benefit from improved L1 cache locality, or if you're talking about 

basically "if HT sharing would be good for performance" ;-)

(btw this is good news, it means this is not an actual power/performance tradeoff, but a "get it right" tradeoff)

