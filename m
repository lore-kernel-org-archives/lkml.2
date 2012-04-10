Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2DJR1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:27:23 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:60842 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2DJR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:27:22 -0400
Message-ID: <4F846D5E.6040107@linux.vnet.ibm.com>
Date: Tue, 10 Apr 2012 22:56:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        nikunj@linux.vnet.ibm.com
Subject: Re: CPU Hotplug rework
References: <4F674649.2000300@linux.vnet.ibm.com> <4F67474A.20707@linux.vnet.ibm.com> <20120405173918.GC8194@linux.vnet.ibm.com> <4F7F4977.4000302@linux.vnet.ibm.com> <20120409171348.GB2430@linux.vnet.ibm.com> <4F84389E.10600@linux.vnet.ibm.com> <20120410154657.GC2428@linux.vnet.ibm.com>
In-Reply-To: <20120410154657.GC2428@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041017-2674-0000-0000-000003FCBF8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 09:16 PM, Paul E. McKenney wrote:

> On Tue, Apr 10, 2012 at 07:11:50PM +0530, Srivatsa S. Bhat wrote:


[This is a quick reply to give the links you requested. I'll reply to the
 other things after I read what you wrote more thoroughly.]

>> Why does my approach help?
> 
> At this point, I must confess that I have lost track of exactly what
> your approach is...


The same old "incomplete" patchset ;-)
(Note that the patch 1/3 is complete. The "incomplete" tag is just because
it is followed by changes only to powerpc (2/3) and sparc (3/3), while
actually, many other places need to be changed. But the first patch in the
series is definitely in full form.

https://lkml.org/lkml/2012/3/1/39
https://lkml.org/lkml/2012/3/1/40
https://lkml.org/lkml/2012/3/1/41

> 
>> It ensures that do_setup() will never occur in parallel with CPU hotplug,
>> at any time. Hence the individual notifiers need not watch their back -
>> they can continue to be non-reentrant and still everything will work fine
>> because we fix it at the callback registration level itself.
>>
>> Honestly, I wrote this patchset to fix issues opened up by the async booting
>> patch[1]. That patch caused boot failures in powerpc [2] because of CPU
>> Hotplug notifier races. And I believe the solution I proposed will fix it.
>>
>> Without the async booting patch, this was more or less a theoretical race.
>> That patch made it not only real but also severe enough to cause boot
>> failures.
>>
>> So, if the async booting design is not being pushed any further, then I
>> guess we can simply ignore this theoretical race altogether and focus on
>> more important issues (I am totally OK with that) ... and possibly revisit
>> this race whenever it bites us again ;-)
>>
>> What do you think?
>>
>> [1]. http://thread.gmane.org/gmane.linux.kernel/1246209
>> [2]. http://thread.gmane.org/gmane.linux.kernel.next/20726/focus=20757
> 
> Neither of the above two URLs points to a patch,


??
Well, the first one points to the async booting patch and the second one points
to a verbal root-cause analysis of the boot failure on powerpc, caused by that
patch.

Let me give equivalent links from lkml.org:
[1]. https://lkml.org/lkml/2012/1/31/286
[2]. https://lkml.org/lkml/2012/2/13/383

 
Regards,
Srivatsa S. Bhat

