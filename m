Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2LLBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:16:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:50024 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab2LLBQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:16:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,263,1355126400"; 
   d="scan'208";a="256119226"
Message-ID: <50C7DA60.7070808@intel.com>
Date: Wed, 12 Dec 2012 09:14:08 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com> <50C722AC.3080806@intel.com> <20121211154819.GC8873@liondog.tnic> <50C75935.1040004@linux.intel.com> <20121211161320.GA28827@liondog.tnic>
In-Reply-To: <20121211161320.GA28827@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 12:13 AM, Borislav Petkov wrote:
> On Tue, Dec 11, 2012 at 08:03:01AM -0800, Arjan van de Ven wrote:
>> On 12/11/2012 7:48 AM, Borislav Petkov wrote:
>>> On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
>>>> Another testing of parallel compress with pigz on Linus' git tree.
>>>> results show we get much better performance/power with powersaving and
>>>> balance policy:
>>>>
>>>> testing command:
>>>> #pigz -k -c  -p$x -r linux* &> /dev/null
>>>>
>>>> On a NHM EP box
>>>>          powersaving               balance   	         performance
>>>> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
>>>> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76
>>>
>>> This looks funny: so "performance" is eating less watts than
>>> "powersaving" and "balance" on NHM. Could it be that the average watts
>>> measurements on NHM are not correct/precise..? On SNB they look as
>>> expected, according to your scheme.
>>
>> well... it's not always beneficial to group or to spread out
>> it depends on cache behavior mostly which is best
> 
> Let me try to understand what this means: so "performance" above with
> 8 threads means that those threads are spread out across more than one
> socket, no?
> 
> If so, this would mean that you have a smaller amount of tasks on each
> socket, thus the smaller wattage.
> 
> The "powersaving" method OTOH fills up the one socket up to the brim,
> thus the slightly higher consumption due to all threads being occupied.
> 

As Arjan said we know the performance increase should be due to the
cache sharing in LLC.
As to power consumption value between powersaving and performance, when
we burn 2 socket CPU, the cpu load is not 100%, so some LCPU still has
time to go idle or to run with low frequency, that also can save some
power.
That's just generalise situation, as to different hardware, different
CPU, they may has different tuning in CPU packages, core, uncore part
etc. So as to different benchmark, the result are also different.


> Is that it?
> 
> Thanks.
> 

