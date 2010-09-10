Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0IJOsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:48:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:37109 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0IJOs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:48:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,346,1280732400"; 
   d="scan'208";a="553334006"
From: "Shi, Alex" <alex.shi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Norbert Preining <preining@logic.at>
CC: "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Sep 2010 22:48:22 +0800
Subject: RE: high power consumption in recent kernels
Thread-Topic: high power consumption in recent kernels
Thread-Index: ActQwaz26/6uXlZGTDyXjsnGIFBjXQAMwW5g
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
References: <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
 <1284107099.402.30.camel@laptop>
In-Reply-To: <1284107099.402.30.camel@laptop>
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

CC to lkml since maybe other guys also have interesting on this. 
Norbert: 
In the powertop source code, the "extra timer interrupt" come from /proc/timer_stats. If my understanding is correct, so many "extra timer interrupt" and the nohz_ratemlimit checking make your system can not go to deep C states. but don't know what the effect for "load balancing tick" come from "extra timer interrupt". So maybe reduce the "extra timer interrupt" is  helpful on your system. Could you like to try this? 



Regards! 
Alex  

>-----Original Message-----
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Friday, September 10, 2010 4:25 PM
>To: Norbert Preining
>Cc: Chen, Tim C; Shi, Alex; arjan@infradead.org; efault@gmx.de; Li, Shaohua; tglx
>Subject: Re: high power consumption in recent kernels
>
>On Fri, 2010-09-10 at 05:51 +0900, Norbert Preining wrote:
>> On Do, 09 Sep 2010, Chen, Tim C wrote:
>> > Have you tried to run powertop to see the causes of the wakeups
>>
>> Of course, in the very first email of the thread I posted the results,
>> here again for your convenience:
>> Top causes for wakeups:
>>   34.2% (185.3)   [kernel scheduler] Load balancing tick
>>   23.9% (129.6)   [extra timer interrupt]
>>   10.8% ( 58.6)   firefox-bin
>>    9.2% ( 49.7)   [iwlagn] <interrupt>
>>    7.2% ( 39.1)   [kernel core] hrtimer_start (tick_sched_timer)
>>    3.9% ( 20.9)   PS/2 keyboard/mouse/touchpad interrupt
>>
>> The problem is the "Load balancing tick" that is far far to high.
>
>Right, which makes perfect sense, delaying going into nohz state simply
>costs power.
>
>One thing we could do is hand over nohz control to the power governor
>(I'm sure Arjan will be thrilled), it could compare the cost of nohz
>enter/exit against the projected sleep time and make an informed
>decision.
>
>Because from what I understand, the nohz enter/exit cycle is what is
>costing you performance on this workload, its simply very expensive to
>prod at timer hardware (which is of course totally intel's own fault for
>giving us crummy timers to begin with).
>

