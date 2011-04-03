Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1DCCtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 22:49:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38859 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab1DCCtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 22:49:01 -0400
Message-ID: <4D97E018.1090504@linux.vnet.ibm.com>
Date: Sun, 03 Apr 2011 08:18:56 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 16/18] 2.6.40: x86 idle APM: remove deprecated
 apm_cpu_idle()
References: <alpine.LFD.2.02.1104010020280.2797@x980> <1301725380-10579-1-git-send-email-lenb@kernel.org> <5d9716021b20302ece48fd486bbad9bcb2502353.1301724243.git.len.brown@intel.com> <20110402124054.49c3a3f4@lxorguk.ukuu.org.uk> <alpine.LFD.2.02.1104021529580.18682@x980> <20110402220021.74ecdb5b@lxorguk.ukuu.org.uk>
In-Reply-To: <20110402220021.74ecdb5b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/03/2011 02:30 AM, Alan Cox wrote:
>> This patch series was posted in reply to a table of contents
>>
>> https://lkml.org/lkml/2011/4/2/8
>>
>> "By the end of this series, pm_idle is removed as a public
>>   x86 idle-loop registration mechanism.  A few other things are
>>   cleaned up in the process."
>
> Ok so lets rewind a bit - why do we want to remove pm_idle rather than
> just fix up the way registration occurs. It's just a symbol, one trivial
> interface that is exported and perhaps wants the export method tidying up.
>
>> Trinabh also replied to you, pointing one of the previous
>> LKML discussions about the mis-use of pm_idle.
>
> And there are misuses of just about every kernel symbol - kmalloc for
> example causes some people a lot of trouble !

There are other problems too. This design of pm_idle has been copied
by numerous other architectures. arm/blackfin/cris/ia64/m32r/m68knomm
/microblaze/mn10300/sh/sparc all have pm_idle. This will keep spreading
in future I guess.

>
>> We'll create a new APM cpuidle driver in Linux (Trinabh prototyped one),
>> and at the same time, schedule it for removal in a year.  Personally,
>> I think it is make-work, and in real-life it is more likely to do
>> more harm than removing apm_idle, but I don't want to stand in the
>> way of process.
>
> So you could just leave it alone - that's less work, less disruption and
> doesn't do any harm at all.
>
> As I read this the plan at the moment otherwise is
>
> 	- churn up all the code
> 	- remove PM idle hook
> 	- rewrite the APM code
> 	- replace the APM code
>
> whereas you could just leave the symbol exported or even just a hook to
> make people to do it right using:
>
> 	int register_pm_idle(function);

A patch was posted to do exactly this; see
https://lkml.org/lkml/2010/10/19/449 . The problem  is that it
results in two places of registration: cpuidle subsystem and
this. It was pointed that 99.99% of people run cpuidle and
we should directly call cpuidle and use its registration mechanism
rather than duplicate code.

Thanks,
-Trinabh
